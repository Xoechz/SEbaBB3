#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "comm.h"

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

int main(int argc, char* argv[])
{
    struct addrinfo hints;
    struct addrinfo* result, * rp;
    int sfd, ret_val;
    struct sockaddr_storage peer_addr;
    socklen_t peer_addr_len;

    if (argc != 3)
    {
        fprintf(stderr, "Usage: %s host port\n", argv[0]);
        exit(1);
    }

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_CANONNAME;

    //getaddrinfo
    ret_val = getaddrinfo(argv[1], argv[2], &hints, &result);
    if (ret_val != 0)
    {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(ret_val));
        exit(1);
    }

    //socket
    for (rp = result; rp != NULL; rp = rp->ai_next)
    {
        sfd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (sfd == -1)
        {
            continue;
        }

        //connect
        if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
        {
            break;
        }

        close(sfd);
    }

    freeaddrinfo(result);

    if (rp == NULL)
    {
        fprintf(stderr, "Could not connect\n");
        exit(1);
    }

    comm(sfd, 0);

    close(sfd);
}