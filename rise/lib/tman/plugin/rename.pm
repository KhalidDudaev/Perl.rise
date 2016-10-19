{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::rename; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1018013856"; sub VERSION {"2016.1018013856"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-rename}} 
		{ package rise::lib::tman::plugin::rename::rename; use rise::core::object::function;  sub rename {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $nname; no warnings; sub nname ():lvalue; *nname = sub ():lvalue { $nname }; use warnings;  ($self,$nname) = ($_[0],$_[1]); 
			$self->basename	= $self->fs->path->basename($nname);
			$self->dst_ext	= $self->fs->path->ext($nname);
			return $self;
		}}
	}
}

1;