{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::notify; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{public-function-plugin}} 
		{ package rise::lib::tman::plugin::notify::plugin; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub plugin {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $msg; no warnings; sub msg ():lvalue; *msg = sub ():lvalue { $msg }; use warnings;  ($msg) = ($_[0]); 
			say $msg;
			return $self;
		}}
	}
}

1;