/*
   This program is a driver to use GT.M from ruby.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ruby.h"
#include "gtmxc_types.h"

#define maxcode	8192	// maximum length of a line of code for the compiler / variable name
#define maxmsg	2048	// maximum length of a GT.M message
#define maxstr	1048576	// maximum length of a value

// GT.M call wrapper
// if an error in call or untrappable error in GT.M, print error on STDERR, clean up and exit
// From GT.M examples
#define CALLGTM(xyz) status = xyz ;             \
  if (status != 0) {                            \
    gtm_zstatus( msg, maxmsg );                 \
    puts("nao tratou");				\
    fprintf( stderr, "%s\n", msg );             \
    gtm_exit();					\
    return status ;                             \
  }

static VALUE m_mumps;
static VALUE c_gtm;

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

static VALUE t_get(VALUE self, VALUE glvn, VALUE subs)
{
  gtm_char_t result[maxstr];
  gtm_char_t errors[maxmsg];
  CALLGTM( gtm_ci( "get", StringValuePtr(glvn), StringValuePtr(subs), &result, &errors ));
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

  gtm_char_t errors[maxmsg];
  CALLGTM( gtm_ci( "init", &errors ));

  m_mumps = rb_define_module("Mumps");
  c_gtm = rb_define_class_under(m_mumps, "Gtm", rb_cObject);
 
  rb_define_method(c_gtm, "open",		t_open, 1);
  rb_define_method(c_gtm, "close",		t_close, 0);
  rb_define_method(c_gtm, "kill",		t_kill, 2);
  rb_define_method(c_gtm, "version",		t_version, 0);
  rb_define_method(c_gtm, "data",		t_data, 2);
  rb_define_method(c_gtm, "get",		t_get, 2);
/*
  rb_define_method(c_gtm, "function",		t_function, 1);
  rb_define_method(c_gtm, "global_directory",	t_global_dir, 1);
  rb_define_method(c_gtm, "increment",		t_increment, 1);
  rb_define_method(c_gtm, "lock",		t_lock, 1);
  rb_define_method(c_gtm, "merge",		t_merge, 1);
  rb_define_method(c_gtm, "next",		t_next, 1);
  rb_define_method(c_gtm, "next_node",		t_next_node, 1);
  rb_define_method(c_gtm, "previous",		t_previous, 1);
  rb_define_method(c_gtm, "previous_node",	t_previous_node, 0);
  rb_define_method(c_gtm, "retrieve",		t_retrieve, 0);
  rb_define_method(c_gtm, "set",		t_set, 1);
  rb_define_method(c_gtm, "unlock",		t_unlock, 1);
  rb_define_method(c_gtm, "update",		t_update, 0);
*/
}

