package Device::WebIO::Device::ADC;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'adc_max_int';
requires 'adc_bit_resolution';
requires 'adc_volt_ref';
requires 'adc_pin_count';
requires 'adc_input_int';


sub adc_input_float
{
    my ($self, $pin) = @_;
    my $in       = $self->adc_input_int( $pin );
    my $max_int  = $self->adc_max_int;
    my $in_float = $in / $max_int;
    return $in_float;
}

sub adc_input_volts
{
    my ($self, $pin) = @_;
    my $in_float = $self->adc_input_float( $pin );
    my $volt_ref = $self->adc_volt_ref;
    my $in_volt  = $volt_ref * $in_float;
    return $in_volt;
}


1;
__END__

