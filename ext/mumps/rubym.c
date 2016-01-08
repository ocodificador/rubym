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
  if (0 != status ) {                           \
    gtm_zstatus( msg, maxmsg );                 \
    fprintf( stderr, "%s\n", msg );             \
    gtm_exit();                                 \
    return status ;                             \
  }


gtm_status_t status;
gtm_char_t msg[maxmsg] = {0};
gtm_char_t value[maxstr] = {0};
gtm_char_t var[maxcode] = {0};
gtm_string_t p_value;

static ID id_push;

VALUE cMumps;


static VALUE t_about(VALUE self)
{
}

static VALUE t_close(VALUE self)
{
  CALLGTM( gtm_exit());
}


static VALUE t_open(VALUE self)
{
  VALUE arr;
  gtm_char_t err[maxmsg] = {0};
  
  CALLGTM( gtm_ci( "gtminit", &err ));
  if (0 != strlen( err )) fprintf( stdout, "%s\n", err);

  CALLGTM( gtm_ci( "gtmkill", "^Capital", &err ));
  if (0 != strlen( err )) fprintf( stdout, "%s\n", err);

  arr = rb_ary_new();
  rb_iv_set(self, "@arr", arr);
  return self;
}

static VALUE t_add(VALUE self, VALUE obj)
{
  VALUE arr;

  arr = rb_iv_get(self, "@arr");
  rb_funcall(arr, id_push, 1, obj);
  return arr;
}

void Init_rubym() {

  if (NULL == getenv( "gtm_dist" )) putenv( "gtm_dist=/usr/local/gtm" );
  if (NULL == getenv( "gtmgbldir" )) putenv("gtmgbldir=$HOME/mumps/globals/mumps.gld");
  if (NULL == getenv( "gtmroutines" )) putenv("gtmroutines=$HOME/mumps/routines/obj($HOME/mumps/routines/src) $gtm_dist");
  if (NULL == getenv( "GTMCI" )) putenv("GTMCI=rubym.ci");
  CALLGTM( gtm_init() );

  cMumps = rb_define_class("RubyM", rb_cObject);
  rb_define_method(cMumps, "about",		t_about, 0);
  rb_define_method(cMumps, "close",		t_close, 0);
  rb_define_method(cMumps, "data",		t_data, 1);
  rb_define_method(cMumps, "function",		t_function, 1);
  rb_define_method(cMumps, "get",		t_get, 1);
  rb_define_method(cMumps, "global_directory",	t_global_dir, 1);
  rb_define_method(cMumps, "increment",		t_increment, 1);
  rb_define_method(cMumps, "kill",		t_kill, 1);
  rb_define_method(cMumps, "lock",		t_lock, 1);
  rb_define_method(cMumps, "merge",		t_merge, 1);
  rb_define_method(cMumps, "next",		t_next, 1);
  rb_define_method(cMumps, "next_node",		t_next_node, 1);
  rb_define_method(cMumps, "open",		t_open, 1);
  rb_define_method(cMumps, "previous",		t_previous, 1);
  rb_define_method(cMumps, "previous_node",	t_previous_node, 0);
  rb_define_method(cMumps, "retrieve",		t_retrieve, 0);
  rb_define_method(cMumps, "set",		t_set, 1);
  rb_define_method(cMumps, "unlock",		t_unlock, 1);
  rb_define_method(cMumps, "update",		t_update, 0);
  id_push = rb_intern("push");
}

