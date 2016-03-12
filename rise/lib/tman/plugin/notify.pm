{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::notify; use rise::core::object::class;  
		{ package rise::lib::tman::plugin::notify::notify; use rise::core::object::function; sub notify {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $msg; no warnings; local *msg; sub msg ():lvalue; *msg = sub ():lvalue {  $msg }; use warnings;  ($self,$msg) = ($_[0],$_[1]); 
			say $msg;
			return $self;
		}}
	}
}

1;