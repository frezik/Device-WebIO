package Device::WebIO::Device::DigitalInput;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'input_pin_count';
requires 'input_pin';


1;
__END__

