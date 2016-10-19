use rise;
{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::puma; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1018013856"; sub VERSION {"2016.1018013856"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-puma}} 
		{ package rise::lib::tman::plugin::puma::puma; use rise::core::object::function;  sub puma {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $conf; no warnings; sub conf ():lvalue; *conf = sub ():lvalue { $conf }; use warnings;  ($self,$conf) = ($_[0],$_[1]); 
			if ($self->src_name){
				my $r; no warnings; sub r ():lvalue; *r = sub ():lvalue { $r }; use warnings;  $r = new rise:: $conf;
				my $c; no warnings; sub c ():lvalue; *c = sub ():lvalue { $c }; use warnings;  $c = $r->compile($self->src_name);
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