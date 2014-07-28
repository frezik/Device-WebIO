package Device::WebIO::Device::DigitalInput;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'input_pin_count';
requires 'input_pin';
requires 'set_as_input';

# There may be more efficient ways to do this on your platform.  Override 
# this if there are.
sub input_port
{
    my ($self) = @_;
    my $value = 0;

    for (0 .. ($self->input_pin_count - 1)) {
        my $pin_value = $self->input_pin( $_ );
        $pin_value //= 0;
        $value |= ($pin_value << $_);
    }

    return $value;
}


1;
__END__

