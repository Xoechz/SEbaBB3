/*
 * Simple comm function to couple two opened streams.
 * We use poll() for this, so the sequence of read events is not important.
 * $Id: comm.c 3397 2022-11-30 14:00:21Z p20018 $
 */

#include <stdio.h>
#include <poll.h>
#include <unistd.h>


void comm(int tfd, int nfd)
{
    int n, i;
    struct pollfd pfd[2];
    char buf[256];

    pfd[0].fd = tfd;            /* terminal */
    pfd[0].events = POLLIN;
    pfd[1].fd = nfd;            /* network */
    pfd[1].events = POLLIN;
    for (;;) {

        /*
         * Wait for events to occur.
         */
        if (poll(pfd, 2, -1) < 0) {
            perror("poll failed");
            break;
        }

        /*
         * Check each file descriptor.
         */
        for (i = 0; i < 2; i++) {
            /*
             * If an error occurred, just return.
             */
            if (pfd[i].revents & (POLLERR | POLLHUP | POLLNVAL))
                return;

            /*
             * If there are data present, read them from
             * one file descriptor and write them to the
             * other one.
             */
            if (pfd[i].revents & POLLIN) {
                n = read(pfd[i].fd, buf, sizeof(buf));
                if (n > 0) {
                    write(pfd[1 - i].fd, buf, n);
                } else {
                    if (n < 0)
                        perror("read failed");
                    return;
                }
            }
        }
    }
}
