{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::notify; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1015032330"; sub VERSION {"2016.1015032330"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-notify}} 
		{ package rise::lib::tman::plugin::notify::notify; use rise::core::object::function;  sub notify {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $msg; no warnings; sub msg ():lvalue; *msg = sub ():lvalue { $msg }; use warnings;  ($self,$msg) = ($_[0],$_[1]); 
			say $msg;
			return $self;
		}}
	}
}

1;