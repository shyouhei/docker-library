#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char **argv)
{
    char *path = getcwd(NULL, 0);
    if (path) {
        free(path);
    }
    return 0;
}
