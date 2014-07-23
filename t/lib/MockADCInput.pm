package MockADCInput;
use v5.12;
use Moo;

has 'max_int',        is => 'ro';
has 'bit_resolution', is => 'ro';
has 'volt_ref',       is => 'ro';
has 'pin_count',      is => 'ro';
has '_input_int',     is => 'ro', default => sub {[]};
with 'Device::WebIO::Device::ADC';


sub mock_set_input
{
    my ($self, $pin, $val) = @_;
    $self->_input_int->[$pin] = $val;
    return 1;
}

sub input_int
{
    my ($self, $pin) = @_;
    return $self->_input_int->[$pin];
}


1;
__END__

