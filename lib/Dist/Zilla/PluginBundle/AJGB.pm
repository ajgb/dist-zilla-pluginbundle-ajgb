use strict;
use warnings;

package Dist::Zilla::PluginBundle::AJGB;

# ABSTRACT: Dist::Zilla plugins for AJGB

use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

# make AutoPrereqs happy
use Dist::Zilla::Plugin::ExecDir ();
use Dist::Zilla::Plugin::ShareDir ();
use Dist::Zilla::Plugin::GatherDir ();
use Dist::Zilla::Plugin::MetaYAML ();
use Dist::Zilla::Plugin::MetaJSON ();
use Dist::Zilla::Plugin::License ();
use Dist::Zilla::Plugin::Manifest ();
use Dist::Zilla::Plugin::Test::Compile ();
use Dist::Zilla::Plugin::PodCoverageTests ();
use Dist::Zilla::Plugin::PodSyntaxTests ();
use Dist::Zilla::Plugin::EOLTests ();
use Dist::Zilla::Plugin::NoTabsTests ();
use Dist::Zilla::Plugin::KwaliteeTests ();
use Dist::Zilla::Plugin::Test::Portability ();
use Dist::Zilla::Plugin::Test::Synopsis ();
use Dist::Zilla::Plugin::PruneCruft ();
use Dist::Zilla::Plugin::ManifestSkip ();
use Dist::Zilla::Plugin::PkgVersion ();
use Dist::Zilla::Plugin::Authority ();
use Dist::Zilla::Plugin::PodWeaver ();
use Dist::Zilla::Plugin::MetaConfig ();
use Dist::Zilla::Plugin::AutoMetaResources ();
use Dist::Zilla::Plugin::AutoPrereqs ();
use Dist::Zilla::Plugin::MakeMaker ();
use Dist::Zilla::Plugin::ModuleBuild ();
use Dist::Zilla::Plugin::InstallGuide ();
use Dist::Zilla::Plugin::ReadmeFromPod ();
use Dist::Zilla::Plugin::Git::NextVersion ();
use Dist::Zilla::Plugin::CopyFilesFromBuild ();
use Dist::Zilla::Plugin::Git::Check ();
use Dist::Zilla::Plugin::CheckChangesHasContent ();
use Dist::Zilla::Plugin::CheckExtraTests ();
use Dist::Zilla::Plugin::TestRelease ();
use Dist::Zilla::Plugin::ConfirmRelease ();
use Dist::Zilla::Plugin::UploadToCPAN ();
use Dist::Zilla::Plugin::NextRelease ();
use Dist::Zilla::Plugin::Git::Commit ();
use Dist::Zilla::Plugin::Git::Tag ();
use Dist::Zilla::Plugin::Git::Push ();

=head1 SYNOPSIS

    # dist.ini
    [@AJGB]

=head1 DESCRIPTION

This is the plugin bundle for AJGB. It's an equivalent to:


    [ExecDir]
    [ShareDir]

    [GatherDir]
    exclude_filename = README
    exclude_filename = dist.ini
    exclude_filename = weaver.ini
    [MetaYAML]
    [MetaJSON]
    [License]
    [Manifest]
    [Test::Compile]
    [PodCoverageTests]
    [PodSyntaxTests]
    [EOLTests]
    [NoTabsTests]
    [KwaliteeTests]
    [Test::Portability]
    [Test::Synopsis]

    [PruneCruft]
    [ManifestSkip]

    [PkgVersion]
    [Authority]
    authority = cpan:AJGB
    do_metadata = 1
    [PodWeaver]
    config_plugin = @AJGB

    [MetaConfig]
    [AutoMetaResources]
    bugtracker.rt = 1
    repository.github = user:ajgb
    homepage = http://search.cpan.org/dist/%{dist}

    [AutoPrereqs]
    [MakeMaker]
    [ModuleBuild]

    [InstallGuide]
    [ReadmeFromPod]

    [Git::NextVersion]
    first_version = 0.01

    [CopyFilesFromBuild]
    copy = README

    [Git::Check]
    allow_dirty = Changes
    allow_dirty = dist.ini
    allow_dirty = README
    [CheckChangesHasContent]
    [CheckExtraTests]
    [TestRelease]
    [ConfirmRelease]

    [UploadToCPAN]

    [NextRelease]
    time_zone = Europe/London
    filename = Changes
    format = %-6v %{yyyy-MM-dd HH:mm:ss}d
    [Git::Commit]
    time_zone = Europe/London
    allow_dirty = README
    allow_dirty = Changes
    [Git::Tag]
    filename = Changes
    tag_format = v%v
    [Git::Push]

=pod

=begin Pod::Coverage

    configure

=end Pod::Coverage

=cut

sub configure {
    my $self = shift;

    my $payload = $self->payload;

    # Dirs
    $self->add_plugins(
        qw(
          ExecDir
          ShareDir
        )
    );

    # FileGatherer
    $self->add_plugins(
        [
            GatherDir =>
              { exclude_filename => [ 'README', 'dist.ini', 'weaver.ini', ], }
        ],
        qw(
          MetaYAML
          MetaJSON
          License
          Manifest
          Test::Compile
          PodCoverageTests
          PodSyntaxTests
          EOLTests
          NoTabsTests
          KwaliteeTests
          Test::Portability
          Test::Synopsis
        ),
    );

    # FilePruner
    $self->add_plugins(
        qw(
          PruneCruft
          ManifestSkip
        ),
    );

    # FileMunger
    $self->add_plugins(
        qw(
          PkgVersion
        ),
        [
            Authority => {
                authority   => 'cpan:AJGB',
                do_metadata => 1,
            }
        ],
        [ PodWeaver          => { config_plugin => '@AJGB', } ],
    );

    # MetaProvider
    $self->add_plugins(
        qw(
          MetaConfig
        ),
        [
            AutoMetaResources => {
                'repository.github' => 'user:ajgb',
                'bugtracker.rt'     => 1,
                'homepage' => 'http://search.cpan.org/dist/%{dist}',
            },
        ],
    );

    # PrereqSource
    $self->add_plugins(
        qw(
          AutoPrereqs
          MakeMaker
          ModuleBuild
        ),
    );

    # PrereqSource / InstallTool
    $self->add_plugins(
        qw(
          ReadmeFromPod
          InstallGuide
        ),
    );

    # VersionProvider
    $self->add_plugins(
        [ 'Git::NextVersion' => { first_version => '0.01', } ],
    );

    # AfterBuild
    $self->add_plugins(
        [ CopyFilesFromBuild => { copy          => 'README', } ],
    );

    # BeforeRelease
    $self->add_plugins(
        [
            'Git::Check' =>
              { allow_dirty => [ 'README', 'dist.ini', 'weaver.ini', ], }
        ],
        qw(
          CheckChangesHasContent
          CheckExtraTests
          TestRelease
          ConfirmRelease
        ),
    );

    # Releaser
    $self->add_plugins(
        qw(
          UploadToCPAN
        )
    );

    # AfterRelease
    $self->add_plugins(
        [
            NextRelease => {
                time_zone => 'Europe/London',
                filename  => 'Changes',
                format    => '%-6v %{yyyy-MM-dd HH:mm:ss}d',
            }
        ],
        [
            'Git::Tag' => {
                filename   => 'Changes',
                tag_format => 'v%v',
            }
        ],
        [ 'Git::Commit'      => {
                time_zone     => 'Europe/London',
                allow_dirty     => [ 'README', 'Changes' ],
            }
        ],
        qw(
          Git::Push
        ),
    );
}

1;
