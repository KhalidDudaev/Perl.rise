use rise;
{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::puma; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{public-function-plugin  private-var-r}} 
         sub r ():lvalue; *__r__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'r') unless (caller eq 'rise::lib::tman::plugin::puma' || caller =~ m/^rise::lib::tman::plugin::puma\b/o); my $self = shift; $self->{'r'} }; *r = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'r') unless (caller eq 'rise::lib::tman::plugin::puma' || caller =~ m/^rise::lib::tman::plugin::puma\b/o); $__RISE_SELF__->{'r'} };   r = new rise::;
		{ package rise::lib::tman::plugin::puma::plugin; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub plugin {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $conf; no warnings; sub conf ():lvalue; *conf = sub ():lvalue { $conf }; use warnings;  ($conf) = ($_[0]); 
			if ($self->src_name){
                # say ">>> " ~ self.src_name if self.src_name;
                my $r; no warnings; sub r ():lvalue; *r = sub ():lvalue { $r }; use warnings;  $r = new rise:: $conf;
                $r->set_conf($conf);
				my $c; no warnings; sub c ():lvalue; *c = sub ():lvalue { $c }; use warnings;  $c = $r->compile($self->src_name);
                # say c.{code};
				# r.__init();
				$self->code_res		    = $c->{code};
				$self->dst_ext		    = 'pm';
				say $c->{info} if $conf->{info};
			}
			return $self;
		}}
	}
}

1;