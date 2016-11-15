{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::rename; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1114205141"; sub VERSION {"2016.1114205141"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-plugin}} 
		{ package rise::lib::tman::plugin::rename::plugin; use rise::core::object::function;  sub plugin {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $nname; no warnings; sub nname ():lvalue; *nname = sub ():lvalue { $nname }; use warnings;  ($nname) = ($_[0]); 
			$self->basename	= $self->fs->path->basename($nname);
			$self->dst_ext	= $self->fs->path->ext($nname);
			return $self;
		}}
	}
}

1;