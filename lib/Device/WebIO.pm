package Device::WebIO;

# ABSTRACT: Duct Tape for the Internet of Things
use v5.12;
use Moo;
use namespace::clean;

has '_device_by_name' => (
    is      => 'ro',
    default => sub {{
    }},
);


sub register
{
    my ($self, $name, $device) = @_;
    $self->_device_by_name->{$name} = $device;
    return 1;
}


sub digital_input
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_device_by_name->{$name};
    return $obj->input_pin( $pin );
}

sub digital_output
{
    my ($self, $name, $pin, $val) = @_;
    my $obj = $self->_device_by_name->{$name};
    $obj->output_pin( $pin, $val );
    return 1;
}



1;
