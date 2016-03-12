use rise::lib::fs;
use rise::lib::tman::fmm;
use Audio::Beep;

{ package rise::lib; use rise::core::object::namespace;   

    { package rise::lib::tman; use rise::core::object::class;   sub __EXPORT__ { {":all"=>[qw/plugin tman start task/],":function"=>[qw/plugin tman start task/],":simple"=>[qw/plugin tman start task/],"plugin"=>[qw/plugin/],"start"=>[qw/start/],"task"=>[qw/task/],"tman"=>[qw/tman/],} }

        my $fs; no warnings; sub fs ():lvalue; *fs = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fs') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $fs }; use warnings;  $fs = new rise::lib::fs;
		my $fmon; no warnings; sub fmon ():lvalue; *fmon = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fmon') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $fmon }; use warnings;  $fmon = new rise::lib::tman::fmm;
		my $snd; no warnings; sub snd ():lvalue; *snd = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $snd }; use warnings;  $snd = new Audio::Beep;

		my $snd_OK; no warnings; sub snd_OK ():lvalue; *snd_OK = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd_OK') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $snd_OK }; use warnings;  $snd_OK = "f'20 d25";
		my $snd_ERR; no warnings; sub snd_ERR ():lvalue; *snd_ERR = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'snd_ERR') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $snd_ERR }; use warnings;  $snd_ERR = "g'20 g10.. g20 g10..";

		my $tlast; no warnings; sub tlast ():lvalue; *tlast = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tlast') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $tlast }; use warnings; 
		my $tcurrent; no warnings; sub tcurrent ():lvalue; *tcurrent = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tcurrent') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $tcurrent }; use warnings; 
		my $tcode; no warnings; sub tcode ():lvalue; *tcode = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tcode') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $tcode }; use warnings;  $tcode = {};
		my $tstack; no warnings; sub tstack ():lvalue; *tstack = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tstack') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $tstack }; use warnings;  $tstack = {};
		my $wcode; no warnings; sub wcode ():lvalue; *wcode = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wcode') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $wcode }; use warnings;  $wcode = {};
		my $wstack; no warnings; sub wstack ():lvalue; *wstack = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wstack') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $wstack }; use warnings;  $wstack = {};
		my $wstart; no warnings; sub wstart ():lvalue; *wstart = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wstart') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $wstart }; use warnings;  $wstart = 0;

		my $code_src; no warnings; sub code_src ():lvalue; *code_src = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'code_src') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $code_src }; use warnings; 
		my $code_res; no warnings; sub code_res ():lvalue; *code_res = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'code_res') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $code_res }; use warnings; 
		my $filename; no warnings; sub filename ():lvalue; *filename = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'filename') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $filename }; use warnings; 
		my $basename; no warnings; sub basename ():lvalue; *basename = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'basename') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $basename }; use warnings; 
		my $src_path; no warnings; sub src_path ():lvalue; *src_path = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'src_path') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $src_path }; use warnings; 
		my $src_name; no warnings; sub src_name ():lvalue; *src_name = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'src_name') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $src_name }; use warnings; 
		# var lsrc_name;
		my $dst_path; no warnings; sub dst_path ():lvalue; *dst_path = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_path') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $dst_path }; use warnings; 
		my $dst_name; no warnings; sub dst_name ():lvalue; *dst_name = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_name') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $dst_name }; use warnings; 
		my $dst_ext; no warnings; sub dst_ext ():lvalue; *dst_ext = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dst_ext') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); $dst_ext }; use warnings;  $dst_ext = 'tman';
		my $ref_path; no warnings; sub ref_path ():lvalue; *ref_path = sub ():lvalue {  $ref_path }; use warnings; 
		my $dst_file; no warnings; sub dst_file ():lvalue; *dst_file = sub ():lvalue {  $dst_file }; use warnings; 

		{ package rise::lib::tman::sndOK; use rise::core::object::function;sub sndOK { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'sndOK') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]); 
			# var sound					= new Audio.Beep;
			$self->snd->play($self->snd_OK);
		}}

		{ package rise::lib::tman::sndERR; use rise::core::object::function;sub sndERR { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'sndERR') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]); 
			# var sound					= new Audio.Beep;
			$self->snd->play($self->snd_ERR);
		}}

		# public function monitor (spath, diff = 2) {
		# 	var tdiff;
		# 	var sname;
		# 	var mname       = 0;
		#
		# 	foreach sname ( self.fs.dir.listf(spath) ) {
		# 		tdiff = time - self.fs.info.mtime(sname);
		# 		next if tdiff > diff;
		# 		mname = sname;
		# 		last if tdiff < diff;
		# 	}
		#
		# 	return mname;
		# }

		{ package rise::lib::tman::src; use rise::core::object::function; sub src {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]); 
			$self->src_path			= $path;
			# self.src_name			= undef;
			# self.src_name			= self.monitor(path,1);
			$self->src_name			= $self->fmon->monitor($path,1);

			# say ">>> " ~ self.src_name;

			if ($self->src_name) {
				# self.lsrc_name			= self.src_name if self.src_name;
				$self->filename			= $self->fs->path->filename($self->src_name);
				$self->basename			= $self->fs->path->basename($self->src_name);
				$self->code_src			= $self->fs->file->read($self->src_name) if $self->src_name;
				# self.dst_ext			= self.fs.path.ext(self.src_name);
			}

			return $self;
		}}

		{ package rise::lib::tman::dst; use rise::core::object::function; sub dst {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  ($self,$path) = ($_[0],$_[1]); 
			if ($self->src_name) {
				$self->dst_path		= $path;

				my $dpath; no warnings; sub dpath ():lvalue; *dpath = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'dpath') unless (caller eq 'rise::lib::tman::dst' || caller =~ m/^rise::lib::tman::dst\b/o); $dpath }; use warnings;  $dpath = $path . $self->referPath();
				my $err; no warnings; sub err ():lvalue; *err = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'err') unless (caller eq 'rise::lib::tman::dst' || caller =~ m/^rise::lib::tman::dst\b/o); $err }; use warnings;  $err = '';

				# say ">>> " ~ dpath;

				if(!$self->fs->dir->isDir($dpath)){
					mkdir $dpath or $err = "ERROR: Cant make dir $dpath";
					if ($err) {
						say $err;
						$self->sndERR();
						return;
					}
					# say "mkdir $dpath";
				}

				$self->code_res		||= $self->code_src;
				$self->dst_file		= $self->basename . '.' . $self->dst_ext;
				$self->dst_name		= $dpath . $self->dst_file;
				$self->fs->file->write($self->dst_name, $self->code_res) if $self->code_res;
				$self->sndOK();
			}
			# self.snd.play(self.snd_OK);
			return $self;
		}}

		{ package rise::lib::tman::referPath; use rise::core::object::function;sub referPath { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'referPath') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]); 
			my $spath; no warnings; sub spath ():lvalue; *spath = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'spath') unless (caller eq 'rise::lib::tman::referPath' || caller =~ m/^rise::lib::tman::referPath\b/o); $spath }; use warnings;  $spath = $self->src_path;
			$spath               =~ s{^([^\*]*).*?$}{$1}sx;
			 my $ref_path; no warnings; sub ref_path ():lvalue; *ref_path = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'ref_path') unless (caller eq 'rise::lib::tman::referPath' || caller =~ m/^rise::lib::tman::referPath\b/o); $ref_path }; use warnings;  ($ref_path) = __RISE_MATCH $self->src_name =~ m{^$spath(.*?)$}sx;
			$self->ref_path		= $self->fs->path->path($ref_path);
			return $self->ref_path;
		}}

		{ package rise::lib::tman::plugin; use rise::core::object::function; sub plugin {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $name; no warnings; local *name; sub name ():lvalue; *name = sub ():lvalue {  $name }; use warnings;  ($self,$name) = ($_[0],$_[1]); 
			no strict;
			require 'rise/lib/tman/plugin/' . $name . '.pm';
			*{"rise::lib::tman::$name"} = *{"rise::lib::tman::plugin::$name::$name"};
		}}

		{ package rise::lib::tman::tman; use rise::core::object::function; sub tman {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]); 
			return $self;
		}}

        { package rise::lib::tman::start; use rise::core::object::function; sub start {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $tname; no warnings; local *tname; sub tname ():lvalue; *tname = sub ():lvalue {  $tname }; use warnings;  ($self,$tname) = ($_[0],$_[1]); 
			$tname ||= 'default';
			say '';
			say line { title => 'tman START' };

			{ my $task; no warnings; local *task; sub task ():lvalue; *task = sub ():lvalue {  $task }; use warnings;  foreach (@ {($self->tstack->{$tname})}) { $task = $_;
				say line { title => 'TASK: ' . $task, char => '-' };
				$self->tcurrent		= $task;
				#self.init();
				$self->tcode->{$task}();
				# if (self.wstart) {
					{ my $wath; no warnings; local *wath; sub wath ():lvalue; *wath = sub ():lvalue {  $wath }; use warnings;  foreach (@ {($self->wstack->{$task})}) { $wath = $_;
						{ my $wcode; no warnings; local *wcode; sub wcode ():lvalue; *wcode = sub ():lvalue {  $wcode }; use warnings;  foreach (@ {($self->wcode->{$task})}) { $wcode = $_;
							# say '### WATCH ' ~ wath;
							$wcode->join if $wcode;
						}}
					}}
				# }
			}}
			$self->wstart = 0;
			say line { title => 'tman END' };
			say '';
        }}

        { package rise::lib::tman::task; use rise::core::object::function; sub task {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $taskName; no warnings; local *taskName; sub taskName ():lvalue; *taskName = sub ():lvalue {  $taskName }; use warnings; my $data; no warnings; local *data; sub data ():lvalue; *data = sub ():lvalue {  $data }; use warnings;  ($self,$taskName,$data) = ($_[0],$_[1],$_[2]); 
			$self->tlast		= $taskName;
            $self->tstack->{$taskName} = [];
			if (ref $data eq 'CODE') {
				$self->tcode->{$taskName} = $data;
				$data = [$taskName];
			}
            __RISE_PUSH $self->tstack->{$taskName}, $data;
        }}

        { package rise::lib::tman::watch; use rise::core::object::function; sub watch {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings; my $data; no warnings; local *data; sub data ():lvalue; *data = sub ():lvalue {  $data }; use warnings;  ($self,$path,$data) = ($_[0],$_[1],$_[2]); 
			$self->wstart = 1;
			# say '###>> ' ~ dump data;
			$self->wcode->{$self->tcurrent}		= [];
			$self->wstack->{$self->tcurrent}	= [];
			my $wc; no warnings; sub wc ():lvalue; *wc = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'wc') unless (caller eq 'rise::lib::tman::watch' || caller =~ m/^rise::lib::tman::watch\b/o); $wc }; use warnings;  $wc = [];

			{ my $tname; no warnings; local *tname; sub tname ():lvalue; *tname = sub ():lvalue {  $tname }; use warnings;  foreach (@ {($data)}) { $tname = $_;
				__RISE_PUSH $wc, $self->watch_go($path, $self->tcode->{$tname});
			}}

			if (ref $data eq 'CODE') {
				# say '>>> ' ~ self.tcurrent;
				__RISE_PUSH $wc, $self->watch_go($path, $data);
				$data = [$self->tcurrent];
			}

			$self->wcode->{$self->tcurrent} = $wc;
			__RISE_PUSH $self->wstack->{$self->tcurrent}, $data;

			return $self;
        }}

		# function action_reg (aname, code) {
		# 	self.tcode.{aname} = code;
		# }

		{ package rise::lib::tman::watch_go; use rise::core::object::thread;sub watch_go  { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'watch_go') unless (caller eq 'rise::lib::tman' || caller =~ m/^rise::lib::tman\b/o); my $thr; $thr = threads->create(sub{my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $path; no warnings; local *path; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings; my $data; no warnings; local *data; sub data ():lvalue; *data = sub ():lvalue {  $data }; use warnings;  ($self,$path,$data) = ($_[0],$_[1],$_[2]); 
			# say '### PATH: ' ~ path ~ ' | DATA: ' ~ dump data;
			while(1){
				$self->src($path);
				if ($self->src_name){
					# say line { title => 'WATCH', char => '~' };
					$data->();
				}
				sleep 1;
			}
		}, @_); { no strict; no warnings; @{rise::lib::tman::THREAD::watch_go}[$thr->tid] = $thr; } return $thr; }}
    }
}

1;