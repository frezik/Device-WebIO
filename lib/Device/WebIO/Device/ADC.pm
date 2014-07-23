package Device::WebIO::Device::ADC;

use v5.12;
use Moo::Role;

with 'Device::WebIO::Device';

requires 'max_int';
requires 'bit_resolution';
requires 'volt_ref';
requires 'pin_count';
requires 'input_int';


sub input_float
{
    my ($self, $pin) = @_;
    my $in       = $self->input_int( $pin );
    my $max_int  = $self->max_int;
    my $in_float = $in / $max_int;
    return $in_float;
}

sub input_volts
{
    my ($self, $pin) = @_;
    my $in_float = $self->input_float( $pin );
    my $volt_ref = $self->volt_ref;
    my $in_volt  = $volt_ref * $in_float;
    return $in_volt;
}


1;
__END__

