#!perl
use Test::More;
use lib '../../lib';
use lib '../../blib/arch/auto/B/Utils';
use B qw(class);
use B::Utils qw( all_roots walkoptree_simple);

my @lines = ();
my $callback = sub
{
  my $op = shift;
  if ('COP' eq B::class($op) and  $op->file eq __FILE__) {
    push @lines, $op->line unless $op->name eq 'null';
  }
};

foreach my $op (values %{all_roots()}) {
  walkoptree_simple( $op, $callback );
}
is_deeply(\@lines, 
          [8, 15, 17, 18, 20, 29, 
           # 30,    # See FIXME: below
           32, 35,
           # 37,
          ],
          'walkoptree_simple lines of ' . __FILE__);

# For testing following if/else in code.
if (@lines) {
  ok(1);     # FIXME: This line isn't coming out.
} else {
  ok(0);
}

done_testing();
__END__
diag join(', ', @lines), "\n";
