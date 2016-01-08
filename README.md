# RubyM #

## A Ruby binding and driver for the GT.M language and database ##

Version 0.0.1 - 2016 Jan 06  - A fork of great NodeM (0.6.2)

## Copyright and License ##

Addon Module written and maintained by David Wicksell <dlw@linux.com>  
Copyright © 2012-2015 Fourth Watch Software LC

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License (AGPL)
as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

***

## Disclaimer ##

RubyM is still in development and its interface may change in future
versions. Use in production at your own risk.

## Summary and Info ##

RubyM will be an open source addon module for Ruby that integrates it
with the [GT.M][] database, providing in-process access to GT.M's database
from Ruby, via GT.M's C call-in interface. From Ruby I hope perform the
basic primitive global database handling operations and also invoke GT.M/Mumps
functions. 


## Installation ##

## Building from source ##


Thanks to David Wicksell <dlw@linux.com> for building NodeM.

### See Also ###

* The [GT.M][] implementation of MUMPS.

[GT.M]: http://sourceforge.net/projects/fis-gtm/

### APIs ###


* *about* or *version* - Display version information
* *close* - Close the database
* *data* - Call the $DATA intrinsic function
* *function* - Call an extrinisic function
* *get* - Call the $GET intrinsic function
* *global_directory* - List the names of the globals in the database
* *increment* - Call the $INCREMENT intrinsic function
* *kill* - Delete a global node, and all of its children
* *lock* - Lock a global or global node incrementally
* *merge* - Merge a global or a global node, to a global or a global node
* *next* or *order* - Call the $ORDER intrinsic function
* *next_node* - Call the $QUERY intrinsic function
* *open* - Open the database
* *previous* - Call the $ORDER intrinsic function in reverse
* *previous_node* - Not yet implemented
* *retrieve* - Not yet implemented
* *set* - Set a global node to a new value
* *unlock* - Unlock a global or global node incrementally, or release all locks
* *update* - Not yet implemented
# rubym
