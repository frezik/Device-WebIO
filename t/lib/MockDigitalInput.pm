package MockDigitalInput;
use v5.12;
use Moo;
use namespace::clean;

use constant input_pin_count => 8;

with 'Device::WebIO::Device::DigitalInput';

has '_pin_input' => (
    is      => 'ro',
    default => sub {[
        (0) x input_pin_count(),
    ]},
);


sub mock_set_input
{
    my ($self, $pin, $val) = @_;
    $self->_pin_input->[$pin] = $val;
    return $val;
}


sub input_pin
{
    my ($self, $pin) = @_;
    return $self->_pin_input->[$pin];
}


1;
__END__

