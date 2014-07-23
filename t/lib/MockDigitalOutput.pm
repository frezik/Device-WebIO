package MockDigitalOutput;
use v5.12;
use Moo;
use namespace::clean;

use constant output_pin_count => 8;

with 'Device::WebIO::Device::DigitalOutput';

has '_pin_output' => (
    is      => 'ro',
    default => sub {[
        (0) x output_pin_count(),
    ]},
);
has '_pin_set_output' => (
    is      => 'ro',
    default => sub {[
        (0) x output_pin_count(),
    ]},
);


sub mock_get_output
{
    my ($self, $pin) = @_;
    return $self->_pin_output->[$pin];
}

sub mock_is_set_output
{
    my ($self, $pin) = @_;
    return $self->_pin_set_output->[$pin];
}


sub output_pin
{
    my ($self, $pin, $val) = @_;
    $self->_pin_output->[$pin] = $val;
    return 1;
}

sub set_as_output
{
    my ($self, $pin) = @_;
    $self->_pin_set_output->[$pin] = 1;
    return 1;
}


1;
__END__

