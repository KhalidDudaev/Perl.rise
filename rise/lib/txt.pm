# text decoration lib
{ package rise::lib::txt; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1017044311"; sub VERSION {"2016.1017044311"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{export:simple-function-line  export:simple-function-box}} sub __EXPORT__ { {":all"=>[qw/line box/],":function"=>[qw/line box/],":simple"=>[qw/line box/],"box"=>[qw/box/],"line"=>[qw/line/],} } 

    { package rise::lib::txt::line; use rise::core::object::function;  sub line {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  ($self,$args) = ($_[0],$_[1]); 
    	my $char; no warnings; sub char ():lvalue; *char = sub ():lvalue { $char }; use warnings;  $char = $args->{'char'} || '#';
    	my $title; no warnings; sub title ():lvalue; *title = sub ():lvalue { $title }; use warnings;  $title = $args->{'title'} || '';
    	my $len; no warnings; sub len ():lvalue; *len = sub ():lvalue { $len }; use warnings;  $len = $args->{'length'} || 75;

    	$title			= $char x 3 . ' ' . $title . ' ' if $title;
    	return $title . $char x ($len - length($title));
    }}

    { package rise::lib::txt::box; use rise::core::object::function;  sub box {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $text; no warnings; sub text ():lvalue; *text = sub ():lvalue { $text }; use warnings; my $title; no warnings; sub title ():lvalue; *title = sub ():lvalue { $title }; use warnings; my $char; no warnings; sub char ():lvalue; *char = sub ():lvalue { $char }; use warnings;  ($self,$text,$title,$char) = ($_[0],$_[1]||'NO TEXT',$_[2]||'',$_[3]||'#'); 
        say $self->line ({ 'title' => $title, 'char' => $char });
        say $text;
        say $self->line ({ 'char' => $char });
    }}

}

1;