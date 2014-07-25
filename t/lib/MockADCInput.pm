package MockADCInput;
use v5.12;
use Moo;

has 'adc_max_int',        is => 'ro';
has 'adc_bit_resolution', is => 'ro';
has 'adc_volt_ref',       is => 'ro';
has 'adc_pin_count',      is => 'ro';
has '_input_int',     is => 'ro', default => sub {[]};
with 'Device::WebIO::Device::ADC';


sub mock_set_input
{
    my ($self, $pin, $val) = @_;
    $self->_input_int->[$pin] = $val;
    return 1;
}

sub adc_input_int
{
    my ($self, $pin) = @_;
    return $self->_input_int->[$pin];
}


1;
__END__

