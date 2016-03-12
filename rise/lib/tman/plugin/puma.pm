use rise;
{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::puma; use rise::core::object::class;  
		{ package rise::lib::tman::plugin::puma::puma; use rise::core::object::function; sub puma {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $conf; no warnings; local *conf; sub conf ():lvalue; *conf = sub ():lvalue {  $conf }; use warnings;  ($self,$conf) = ($_[0],$_[1]); 
			if ($self->src_name){
				my $r; no warnings; sub r ():lvalue; *r = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'r') unless (caller eq 'rise::lib::tman::plugin::puma::puma' || caller =~ m/^rise::lib::tman::plugin::puma::puma\b/o); $r }; use warnings;  $r = new rise $conf;
				my $c; no warnings; sub c ():lvalue; *c = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'c') unless (caller eq 'rise::lib::tman::plugin::puma::puma' || caller =~ m/^rise::lib::tman::plugin::puma::puma\b/o); $c }; use warnings;  $c = $r->compile($self->src_name);
				$r = undef;
				$self->code_res		= $c->{code};
				$self->dst_ext		= 'pm';
				say $c->{info} if $conf->{info};
			}
			return $self;
		}}
	}
}

1;