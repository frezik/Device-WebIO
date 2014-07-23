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


sub set_as_input
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $obj->set_as_input( $pin );
    return 1;
}

sub set_as_output
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    $obj->set_as_output( $pin );
    return 1;
}

sub digital_input
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->input_pin( $pin );
}

sub digital_output
{
    my ($self, $name, $pin, $val) = @_;
    my $obj = $self->_get_obj( $name );
    $obj->output_pin( $pin, $val );
    return 1;
}


sub _get_obj
{
    my ($self, $name) = @_;
    my $obj = $self->_device_by_name->{$name};
    return $obj;
}


1;
