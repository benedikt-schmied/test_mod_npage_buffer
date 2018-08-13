#include <stdint.h>
#include <stddef.h>

#include <mod_npage_buffer.h>

/**
 * write function
 */
static int test_seek(int _fd, int _off, unsigned off);

/**
 * read function
 */
static int test_read(int _fd, char *_dst, unsigned _len);

/**
 * write function
 */
static int test_write(int _fd, char *_src, unsigned _len);

/**
 *
 */
int main(int argc, char *argv[])
{
    /* automatic variables */
    mod_npage_hdl_t hdl;
    struct mod_npage_buffer_attr arg;

    /* executable statements */

    /* fill up the configuration structure */
    arg.pagesz = 0x20;
    arg.seek    = test_seek;
    arg.read    = test_read;
    arg.write   = test_write;

    /* call the open function */
    mod_npage_buffer__open(&hdl, &arg);
    return 0;
}

/**
 * write function
 */
static int test_seek(int _fd, int _off, unsigned off)
{
    printf("%s", __FUNCTION__);
    return 0;
}

/**
 * read function
 */
static int test_read(int _fd, char *_dst, unsigned _len)
{
    printf("%s", __FUNCTION__);
    return 0;
}

/**
 * write function
 */
static int test_write(int _fd, char *_src, unsigned _len)
{
    printf("%s", __FUNCTION__);
    return 0;
}
