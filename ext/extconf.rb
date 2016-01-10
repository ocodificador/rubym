require "mkmf"

$INCFLAGS << ' -I$(gtm_dist)'
$LDFLAGS << ' -L $(gtm_dist) -Wl,-rpath=$(gtm_dist) -lgtmshr'

create_makefile('gtm/rubym', 'gtm')
