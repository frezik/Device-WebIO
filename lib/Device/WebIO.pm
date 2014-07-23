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

sub adc_count
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->pin_count;
}

sub adc_resolution
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->bit_resolution;
}

sub adc_max_int
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->max_int;
}

sub adc_volt_ref
{
    my ($self, $name) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->volt_ref;
}

sub adc_input_int
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->input_int( $pin );
}

sub adc_input_float
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->input_float( $pin );
}

sub adc_input_volts
{
    my ($self, $name, $pin) = @_;
    my $obj = $self->_get_obj( $name );
    return $obj->input_volts( $pin );
}


sub _get_obj
{
    my ($self, $name) = @_;
    my $obj = $self->_device_by_name->{$name};
    return $obj;
}


1;
