package Device::WebIO::Device::DigitalOutput;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'output_pin_count';
requires 'output_pin';
requires 'set_as_output';


1;
__END__

