#!perl
use Test::More 0.88;


use B qw(class);
use B::Utils qw( all_roots walkoptree_simple);

my @lines = ();
my $callback = sub
{
  my $op = shift;
  if ('COP' eq B::class($op) and  $op->file eq __FILE__) {
    push @lines, $op->line; # includes ex-nextstate COPs
  }
};

foreach my $op (values %{all_roots()}) {
  walkoptree_simple( $op, $callback );
}
my $expected = [8, 9, 17, 17, 18, 20, 22, 23, 25, 26, 28, 29,
                32, 37, 38, 40, 43];
if ("$]" < 5.045004) {
  $expected = [8, 15, 17, 18, 20, 24, 27, 31, 36, 42];
}
if ("$]" < 5.045003) {
  $expected =  [8, 15, 17, 18, 20, 24, 27, 31, 36, 39, 42];
}
if ("$]" < 5.007) {
  $expected =  [8, 15, 17, 18, 17, 20, 24, 27, 31, 36, 39, 42];
}

is_deeply(\@lines,
          $expected,
          'walkoptree_simple lines of ' . __FILE__);

# For testing following if/else in code.
if (@lines) {
  ok(1);
} else {
  ok(0);
}

done_testing();
__END__
diag join(', ', @lines), "\n";
