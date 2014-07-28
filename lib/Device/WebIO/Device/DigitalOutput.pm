package Device::WebIO::Device::DigitalOutput;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'output_pin_count';
requires 'output_pin';
requires 'set_as_output';

# There may be more efficient ways to do this on your platform.  Override 
# this if there are.
sub output_port
{
    my ($self, $out) = @_;

    for (0 .. ($self->output_pin_count - 1)) {
        my $pin_out = ($out >> $_) & 1;
        $self->output_pin( $_, $pin_out );
    }

    return 1;
}


1;
__END__

