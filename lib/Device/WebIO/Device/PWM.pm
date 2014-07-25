package Device::WebIO::Device::PWM;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'pwm_max_int';
requires 'pwm_bit_resolution';
requires 'pwm_pin_count';
requires 'pwm_output_int';


sub pwm_output_float
{
    my ($self, $pin, $out) = @_;
    my $max_int = $self->pwm_max_int;
    my $int_out = sprintf( '%.0f', $max_int * $out );
    return $self->pwm_output_int( $pin, $int_out );
}


1;
__END__

