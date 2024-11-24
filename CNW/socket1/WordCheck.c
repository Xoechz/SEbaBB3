/*
 * ---------------------------------------------------
 * WordCheck.c	a simple console game
 * $Id: WordCheck.c 3580 2024-01-10 11:24:09Z p20018 $
 * ---------------------------------------------------
 */
#pragma GCC diagnostic ignored "-Wformat-truncation"

#include<errno.h>
#include<syslog.h>
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include <unistd.h>             // 150413 this was forgotten

#define WORDLEN 		80
#define INCOMPLETE 		1
#define WON 			2
#define LOST 			3

 /*
  * serve() plays Hangman with a single player.
  * It receives a file handle which shall be opened before.
  * User's input is read from this handle and Hangman's output is written to
  * it.
  * serve() either returns
  *   - on a regular termination of the game -- end of lives or word is guessed
  *   - or on a severe error at the input stream.
  */


static char* words[] = {        /* the words to be guessed */
    "nccyvpngvbaynlre",
    "cerfragngvbaynlre",
    "frffvbaynlre",
    "genafcbegynlre",
    "qngnyvaxynlre",
    "argjbexynlre",
    "culfvpnyynlre",
    "genafzvffvbapbagebycebgbpby",
    "hfreqngntenzcebgbpby",
    "vagrearg",
    "esp",
    "nqqerfferfbyhgvbacebgbpby",
    "qlanzvpubfgpbasvthengvbacebgbpby",
    "sentzragngvba",
    "argjbexnpprffynlre",
    "vagreargpbagebyzrffntrcebgbpby",
    "svyrgenafsrecebgbpby",
    "ulcregrkggenafsrecebgbpby",
    "fvzcyrznvygenafsrecebgbpby",
    "cbfgbssvprcebgbpby",
    "frpherfuryy",
    "qbznvaanzrflfgrz",
    "frdhraprahzore",
    "npxabjyrqtrzragahzore",
    "fhoargznfx",
    "yvahk",
    "onfu",
    "nfgrevk",
    "boryvk",
    "zvenphyvk",
    "vqrsvk",
    "znwrfgvk",
    "thgrzvar",
    "zrguhfnyvk",
    "ireyrvuavk",
    "gebhoneqvk",
};


/*
 * 'encode' a character
 */
 // [gj 201204]
static char rot13(char c)
{
    if ((('a' <= c) & (c <= 'z'))
        || (('A' <= c) & (c <= 'Z')))
    {
        char base = c < 'a' ? 'A' : 'a';
        char offset = c - base;
        offset = (offset + 13) % 26;
        c = base + offset;
    }
    return c;
}

/*
 * 'encode' a string
 */
static char* rot13_string(const char* s)
{
    static char encoded[WORDLEN];
    int i = 0;

    while (*s)
    {
        encoded[i++] = rot13(*s++);
    }
    encoded[i] = 0;
    return encoded;
}

void serve(int fd               /* stream to read from and write to */
)
{
    int max_lives = 10;         /* number of guesses we offer */

    char part_word[WORDLEN],
        * whole_word,
        guess_word[WORDLEN], hostname[WORDLEN], outbuff[WORDLEN];
    int lives, word_len, game_status = INCOMPLETE, hits, i;
    int ret;
    time_t timer;
    struct tm* t;

    /*
     * initialize
     */
    lives = max_lives;

    /*
     * pick up a random word
     */
    time(&timer);
    t = localtime(&timer);
    whole_word = rot13_string(words[(t->tm_sec + rand()) %
        (sizeof(words) / sizeof(char*))
    ]);
    word_len = strlen(whole_word);
    syslog(LOG_USER | LOG_INFO, "we choose the word \"%s\"", whole_word);

    /*
     * initialize empty word
     */
    for (i = 0; i < word_len; i++)
        part_word[i] = '-';
    part_word[i] = '\0';

    /*
     * output empty word
     */
    snprintf(outbuff, WORDLEN, "%s  lives:%d \n", part_word, lives);
    write(fd, outbuff, strlen(outbuff));

    /*
     * do the game
     */
    while (game_status == INCOMPLETE)
    {
        while ((ret = read(fd, guess_word, WORDLEN)) < 0)
        {

            /*
             * restart if interrupted by signal ??
             */
            if (errno != EINTR)
            {
                perror("reading players guess");
                // exit(1); [gj 160226]
                return;
            }
            printf("re-starting the read\n");
        }

        // [gj 170404] special treatment for "out-of-time closed socket from other host"
        //printf("read returned %d\n", ret);
        if (!ret)
        {             // connection closed by other host
            return;
        }

        /*
         * check for hits
         */
        hits = 0;
        for (i = 0; i < word_len; i++)
        {
            if (guess_word[0] == whole_word[i])
            {
                hits = 1;
                part_word[i] = whole_word[i];
            }                   /* if */
        }                       /* for */

        /*
         * check for end of game
         */
        if (!hits)
        {
            lives--;
            if (lives == 0)
            {
                game_status = LOST;
            }                   /* game is over */
        }                       /* lost one life */
        if (strcmp(part_word, whole_word) == 0)
        {
            /*
             * he did it
             */
            game_status = WON;
            sprintf(outbuff, "You won!\n");
            write(fd, outbuff, strlen(outbuff));
            return;
        }
        else if (lives == 0)
        {
            game_status = LOST;
            strcpy(part_word, whole_word);
        }

        /*
         * show word
         */
        snprintf(outbuff, WORDLEN, "%s  lives: %d \n", part_word, lives);
        write(fd, outbuff, strlen(outbuff));
        if (game_status == LOST)
        {
            snprintf(outbuff, WORDLEN, "\nGame over.\n");
            write(fd, outbuff, strlen(outbuff));
        }                       /* he looses */
    }                           /* game is incomplete */
}                               /* serve */

#ifdef CHEAT
/* generate rot13 version of words to be guessed */
int main()
{
    for (int i = 0; i < sizeof(words) / sizeof(*words); i++)
    {
        printf("\"%s\",\n", rot13_string(words[i]));
    }
}
#endif
