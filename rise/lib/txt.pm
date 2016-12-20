# text decoration lib
{ package rise::lib::txt; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{export:simple-function-line  export:simple-function-box}} sub __EXPORT__ { {":all"=>[qw/line box/],":function"=>[qw/line box/],":simple"=>[qw/line box/],"box"=>[qw/box/],"line"=>[qw/line/],} } 

    { package rise::lib::txt::line; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub line {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $data; no warnings; sub data ():lvalue; *data = sub ():lvalue { $data }; use warnings;  ($data) = ($_[0]); 
    	my $char; no warnings; sub char ():lvalue; *char = sub ():lvalue { $char }; use warnings;  $char = $data->{'char'} || '#';
    	my $title; no warnings; sub title ():lvalue; *title = sub ():lvalue { $title }; use warnings;  $title = $data->{'title'} || '';
    	my $len; no warnings; sub len ():lvalue; *len = sub ():lvalue { $len }; use warnings;  $len = $data->{'length'} || 75;

    	$title			= $char x 3 . ' ' . $title . ' ' if $title;
    	return $title . $char x ($len - length($title));
    }}

    { package rise::lib::txt::box; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub box {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $text; no warnings; sub text ():lvalue; *text = sub ():lvalue { $text }; use warnings; my $title; no warnings; sub title ():lvalue; *title = sub ():lvalue { $title }; use warnings; my $char; no warnings; sub char ():lvalue; *char = sub ():lvalue { $char }; use warnings;  ($text,$title,$char) = ($_[0]||'NO TEXT',$_[1]||'',$_[2]||'#'); 
        my $t; no warnings; sub t ():lvalue; *t = sub ():lvalue { $t }; use warnings; 
        $t .= $self->line ({ 'title' => $title, 'char' => $char }) . "\n";
        $t .= $text . "\n";
        $t .= $self->line ({ 'char' => $char });
        return $t;
    }}

}

1;