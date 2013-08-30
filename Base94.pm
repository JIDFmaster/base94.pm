package Base94;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $base94_digits);

use Carp;
use Exporter;
use Math::BigInt qw(:constant);
$VERSION = '0.2';

@ISA = qw(Math::BigInt);
@EXPORT = qw();
@EXPORT_OK = qw(from_base94 to_base94);

=head1 NAME

Math::Base85 - Perl extension for base 85 numbers, as referenced by RFC 1924

=head1 SYNOPSIS

  use Math::Base85;

  $bigint = from_base85($number);
  $b85str = to_base85($bigint);

=head1 DESCRIPTION

RFC 1924 describes a compact, fixed-size representation of IPv6
addresses which uses a base 85 number system.  This module handles
some of the uglier details of it.

The base 85 numbers (from 0 to 84) are as follows:

    0..9 A..Z a..z ! # $ % & ( ) * + - ; < = > ? @ ^ _ ` { | } ~

At the moment, there's not much in this module.  But it should be
sufficient for the purposes of RFC 1924.

This module has a variable called C<$Math::Base85::base85_digits>,
which is a string containing the digits of the base 85 alphabet
from lowest (0) to highest (~), in that order.

Additionally, the following two functions are defined for general
use.  (They will be exported upon request.)

=cut

$base94_digits = join('', 
    '0' .. '9', 
    'A' .. 'Z', 
    'a' .. 'z', 
    '!', '"', '#', qw"$ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~",
);

if (length $base94_digits != 94) {
    die "shit ".length $base94_digits
} 

# Maybe we can make this a little more general...

use constant B94_BASE => 94;

=pod

=head1 from_base85

=head2 Parameters

A string composed of valid base 85 digits.

=head2 Returns

A C<Math::BigInt> object representing the number.

=cut

sub from_base94
{
    my $num = shift;
    my @digits = split(//, $num);
    my $answer = new Math::BigInt "0";
    my $n;
    my $d;
    while (defined($d = shift @digits)) {
    $answer = $answer * B94_BASE;
    $n = index($base94_digits, $d);
    if ($n < 0) {
        croak __PACKAGE__ . "::from_base85 -- invalid base 85 digit $d";
    }
    $answer = $answer + $n;
    }
    my $r = $answer->as_hex();
    $r =~ s/0x//g;
    return $r
}

=pod

=head1 to_base85

=head2 Parameters

A C<Math::BigInt> object.

=head2 Returns

A string of base 85 digits representing the number.

=cut

sub to_base94
{
    my $num_h = shift;
    my $num = Math::BigInt->from_hex("0x$num_h");
    my @digits;
    my $q;
    my $r;
    my $d;
    while ($num > 0) {
    $q = $num / B94_BASE;
    $r = $num % B94_BASE;
    $d = substr($base94_digits, $r, 1);
    unshift @digits, $d;
    $num = $q;
    }
    unshift @digits, '0' unless (@digits);
    return join('', @digits);
}

=head1 AUTHOR

Tony Monroe <tmonroe+perl@nog.net>

=head1 SEE ALSO

perl(1).

=cut

1;
__END__
