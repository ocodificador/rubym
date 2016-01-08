/* This program is a driver to demonstrate a C main() program that calls in to GT.M.
   No claim of copyright is made with respect to this code.

   On x86 GNU/Linux (64-bit Ubuntu 10.10), this program was compiled and run with:
     gcc -c gtm_access.c -I$gtm_dist
     gcc gtm_access.o -o gtm_access -L $gtm_dist -Wl,-rpath=$gtm_dist -lgtmshr
     ./gtm_access ; stty sane
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ruby.h"
#include "gtmxc_types.h"

// GT.M limits - you can use smaller numbers if your application doesn't need such large strings
#define maxcode 8192 // maximum length of a line of code for the compiler / variable name
#define maxmsg 2048 // maximum length of a GT.M message
#define maxstr 1048576 // maximum length of a value

// GT.M call wrapper - if an error in call or untrappable error in GT.M, print error on STDERR, clean up and exit
#define CALLGTM(xyz) status = xyz ;             \
  if (status != 0) {                            \
    gtm_zstatus( msg, maxmsg );                 \
    fprintf( stderr, "%s\n", msg );             \
    gtm_exit();                                 \
    return status ;                             \
  }

//static VALUE m_rubym;
//static VALUE c_gtm;
static VALUE c_mumps;

gtm_status_t status;
gtm_char_t msg[maxmsg] = {0};

static VALUE t_version(VALUE self)
{
  gtm_char_t result[maxstr];
  gtm_char_t errors[maxmsg];
  CALLGTM( gtm_ci( "version", &result, &errors ));
  return rb_str_new2(result);
}


static VALUE t_data(VALUE self, VALUE glvn, VALUE subs)
{
  gtm_char_t result[maxstr];
  gtm_char_t errors[maxmsg];
  CALLGTM( gtm_ci( "data", StringValuePtr(glvn), StringValuePtr(subs), &result, &errors ));
  return (strlen( errors ) == 0) ? rb_str_new2(result) : Qnil;
}

static VALUE t_open(VALUE self)
{
  gtm_char_t errors[maxmsg];
  CALLGTM( gtm_ci( "gtminit", &errors ));
  return self;
}

static VALUE t_close(VALUE self)
{
  CALLGTM( gtm_exit());
}


static VALUE t_kill(VALUE self, VALUE glvn, VALUE subs)
{
  gtm_char_t result[maxstr];
  gtm_char_t errors[maxmsg];
  CALLGTM( gtm_ci( "kill", StringValuePtr(glvn), StringValuePtr(subs), &result, &errors ));
  return (strlen( errors ) == 0) ? rb_str_new2(result) : Qnil;
}

void Init_rubym() {

  if (NULL == getenv( "gtm_dist" )) putenv( "gtm_dist=/usr/local/gtm" );
  if (NULL == getenv( "gtmgbldir" )) putenv("gtmgbldir=$HOME/mumps/globals/mumps.gld");
  if (NULL == getenv( "gtmroutines" )) putenv("gtmroutines=$HOME/mumps/routines/obj($HOME/mumps/routines/src) $gtm_dist");
  if (NULL == getenv( "GTMCI" )) putenv("GTMCI=rubym.ci");

  CALLGTM( gtm_init() );

  c_mumps = rb_define_class("RubyM", rb_cObject);
 
  rb_define_method(c_mumps, "open",		t_open, 1);
  rb_define_method(c_mumps, "close",		t_close, 0);
  rb_define_method(c_mumps, "kill",		t_kill, 2);
  rb_define_method(c_mumps, "version",		t_version, 0);
  rb_define_method(c_mumps, "data",		t_data, 2);
/*
  rb_define_method(c_mumps, "function",		t_function, 1);
  rb_define_method(c_mumps, "get",		t_get, 1);
  rb_define_method(c_mumps, "global_directory",	t_global_dir, 1);
  rb_define_method(c_mumps, "increment",		t_increment, 1);
  rb_define_method(c_mumps, "lock",		t_lock, 1);
  rb_define_method(c_mumps, "merge",		t_merge, 1);
  rb_define_method(c_mumps, "next",		t_next, 1);
  rb_define_method(c_mumps, "next_node",		t_next_node, 1);
  rb_define_method(c_mumps, "previous",		t_previous, 1);
  rb_define_method(c_mumps, "previous_node",	t_previous_node, 0);
  rb_define_method(c_mumps, "retrieve",		t_retrieve, 0);
  rb_define_method(c_mumps, "set",		t_set, 1);
  rb_define_method(c_mumps, "unlock",		t_unlock, 1);
  rb_define_method(c_mumps, "update",		t_update, 0);
*/
}

