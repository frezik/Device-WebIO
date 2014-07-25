package Device::WebIO::Exceptions;

use v5.12;
use base 'Exception::Tiny';

package Device::WebIO::PinDoesNotExistException;

use base 'Device::WebIO::Exceptions';


package Device::WebIO::FunctionNotSupportedException;

use base 'Device::WebIO::Exceptions';


1;
__END__

