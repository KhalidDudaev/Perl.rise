{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::rename; use rise::core::object::class;  
		{ package rise::lib::tman::plugin::rename::rename; use rise::core::object::function; sub rename {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $nname; no warnings; local *nname; sub nname ():lvalue; *nname = sub ():lvalue {  $nname }; use warnings;  ($self,$nname) = ($_[0],$_[1]); 
			$self->basename	= $self->fs->path->basename($nname);
			$self->dst_ext	= $self->fs->path->ext($nname);
			return $self;
		}}
	}
}

1;