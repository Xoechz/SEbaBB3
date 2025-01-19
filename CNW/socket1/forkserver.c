#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <bits/waitflags.h>
#include <errno.h>
#include <signal.h>
#include <bits/sigaction.h>
#include <sys/wait.h>

#include "WordCheck.h"

#define MAX_STR_LEN 128

int get_port(const struct sockaddr* sa)
{
    switch (sa->sa_family)
    {
    case AF_INET:
        return ntohs(((struct sockaddr_in*)sa)->sin_port);

    case AF_INET6:
        return ntohs(((struct sockaddr_in6*)sa)->sin6_port);

    default:
        return -1;
    }
}


const char* get_ip_str(const struct sockaddr* sa, char* s, size_t maxlen)
{
    switch (sa->sa_family)
    {
    case AF_INET:
        inet_ntop(AF_INET, &(((struct sockaddr_in*)sa)->sin_addr), s, maxlen);
        break;

    case AF_INET6:
        inet_ntop(AF_INET6, &(((struct sockaddr_in6*)sa)->sin6_addr), s, maxlen);
        break;

    default:
        strncpy(s, "Unknown AF", maxlen);
        return NULL;
    }

    return s;
}
int child_counter = 0;

static void handler_sigchild(int signo)
{
    int child_process_id, status, saved_errno;
    saved_errno = errno;

    while ((child_process_id = waitpid(-1, &status, WNOHANG)) > 0)
    {
        printf("Child %d terminated\n", child_process_id);
        child_counter--;
    }

    printf("Child counter: %d\n", child_counter);

    errno = saved_errno;
}

int main(int argc, char* argv[])
{
    struct addrinfo hints;
    struct addrinfo* result, * rp;
    int main_sock, client_sock, ret_val;
    struct sockaddr_storage peer_addr;
    socklen_t peer_addr_len;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s port\n", argv[0]);
        exit(1);
    }

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;

    //getaddrinfo
    ret_val = getaddrinfo(NULL, argv[1], &hints, &result);
    if (ret_val != 0)
    {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(ret_val));
        exit(1);
    }

    //socket
    for (rp = result; rp != NULL; rp = rp->ai_next)
    {
        main_sock = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (main_sock == -1)
        {
            continue;
        }

        int yes = 1;
        if (setsockopt(main_sock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1)
        {
            perror("setsockopt");
            exit(1);
        }

        //bind
        if (bind(main_sock, rp->ai_addr, rp->ai_addrlen) == 0)
        {
            break;
        }

        close(main_sock);
    }

    freeaddrinfo(result);

    if (rp == NULL)//no address succeeded
    {
        perror("bind");
        exit(1);
    }

    //listen
    if (listen(main_sock, 10) == -1)
    {
        perror("listen");
        exit(1);
    }

    printf("Server Port is %s\n", argv[1]);

    struct sigaction sa;
    sa.sa_handler = handler_sigchild;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;
    if (sigaction(SIGCHLD, &sa, NULL) == -1)
    {
        perror("sigaction");
        exit(1);
    }

    for (;;)
    {
        //accept
        peer_addr_len = sizeof(struct sockaddr_storage);
        client_sock = accept(main_sock, (struct sockaddr*)&peer_addr, &peer_addr_len);

        if (client_sock == -1)
        {
            perror("accept");
            exit(1);
        }

        //print client info
        char ip_str[INET6_ADDRSTRLEN];
        printf("Connection from %s\n", get_ip_str((struct sockaddr*)&peer_addr, ip_str, sizeof(ip_str)));
        printf("Port: %d\n", get_port((struct sockaddr*)&peer_addr));

        ret_val = fork();
        if (ret_val == -1)
        {
            perror("fork");
            exit(1);
        }
        else if (ret_val > 0)
        {
            //parent
            close(client_sock);
            child_counter++;
            printf("Child counter: %d\n", child_counter);
        }
        else
        {
            //child
            close(main_sock);

            //read & write
            serve(client_sock);

            //close
            close(client_sock);

            exit(0);
        }
    }
}