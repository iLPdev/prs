# Procedural Realms Script

<!-- PROJECT BANNER 
<div>
    <br />
    <p align="center">
        <a href=".github/images/discMapper_logo.png">
          <img src=".github/images/discMapper_logo.png" alt="discMapper Logo" width="auto" height="auto">
        </a>
    </p>  
</div>
-->

<!-- PROJECT BADGES -->
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/iLPdev/discMapper?include_prereleases&sort=semver&style=flat-square)](https://github.com/iLPdev/discMapper/releases/latest) <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)<!-- ALL-CONTRIBUTORS-BADGE:END --> [![Issues][issues-shield]][issues-url]
[![GPL License][license-shield]][license-url]
[![standard-readme compliant][standard-readme-shield]][standard-readme-url]
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Mudlet/Mudlet?style=flat-square&label=client&sort=semver)](https://github.com/Mudlet/Mudlet/releases/latest)

<!-- SHORT DESCRIPTION -->
<p align="center">
    Mudlet script for Procedural Realms MUD
    <br />
</p>

<!-- LONG DESCRIPTION 
The discMapper project gives [Discworld MUD](http://discworld.starturtle.net/lpc) players improved access to the advanced mapping features of the [Mudlet](https://www.mudlet.org) MUD client. By leveraging the specific "out of band" packets sent by Discworld MUD's server, discMapper correcly identifies rooms, stops creation of duplicate rooms, and accurately tracks your character's location on the map as you move about the disc. Additional convenience features include autosetting colors and symbols on the map based on the room type.

Project Link: [https://github.com/iLPdev/discMapper]
-->

<!-- TABLE OF CONTENTS 
## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Maintainer](#maintainer)
- [Acknowledgements](#acknowledgements)
- [Contributing](#contributing)
- [License](#license)
-->
<!-- ABOUT THE PROJECT 
## Background

<p align="center">
    <a href=".github/images/screenshot_0.6.0-beta_downtown_AM.jpg" alt="" title="Downtown Ankh-Morpork"><img src=".github/images/screenshot_0.6.0-beta_downtown_AM.jpg" height="300" align="left"/></a> <a href=".github/images/screenshot_0.6.0-beta_styleRooms.jpg" alt="" title="Downtown Ankh-Morpork"><img src=".github/images/screenshot_0.6.0-beta_styleRooms.jpg" height="300" align="float"/></a>
</p>

### History

The discMapper project was unofficially started sometime during the early weeks of April 2020. The Coronavirus Pandemic and Stay-at-Home orders prompted [@Stack](https://github.com/iLPdev) to make an unexpected return to MUDs after more than two decades. A robust and stable LPmud derivative under continuous development since 1991, [Discworld MUD](http://discworld.starturtle.net/lpc) seemed like a promising quarantine-life distraction from our collective global trauma. Various MUD clients were tested. Among them, [Mudlet](https://www.mudlet.org) appeared the most desirable. Unfortunately, of the regular 80-100 online Discworld players, almost none appeared to be using Mudlet due to a severe lack of game-specific scripts relative to an old, alternative MUD client. A college try was made with the amazing scripts available for the alternative client, but it was too late... Mudlet's clean, modern appeal and advanced features had already won out -- if only there were Mudlet scripts for Discworld MUD.

Inspired and seeking assistance in learning, the [Mudlet Discord chat server](https://discord.gg/S9zVg7H) was found to be a friendly, engaging community of creative and dedicatedly caring coders. After several weeks of struggling to achieve reliable mapping with text-based detection routines, a basic GMCP room detection approach was developed as possible solution. Considerable progress was made in learning and incoporating game-specific GMCP support into an existing [generic mapping script](https://github.com/Mudlet/Mudlet/blob/development/src/mudlet-lua/lua/generic-mapper/generic_mapper.xml).

On May 24, 2020, [@vadi2](https://github.com/vadi2) was gracious enough to volunteer three hours helping @Stack live on a public audio chat. After initial assessment of the unique challenges of developing a custon mapping script for Discworld MUD, we spent a brief period exploring extension of the [IRE mapping script](https://github.com/IRE-Mudlet-Mapping/ire-mapping-script), but affirmed the lack of GMCP exit data supplied by [FluffOS](<(https://github.com/fluffos/fluffos)>) was too great an obstacle. A return was made to the hybrid approach of adding GMCP room detection/indexing to the text-based exit detection of the generic mapping script included with Mudlet. At the end of three hours, we had achieved basic functionality with only a couple minor issues.

Unfortunately, it was soon realized that cleanly installing this initial version of the discMapper to a new Mudlet profile with no prior mapping settings caused the script to break entirely. Many confused hours were spent chasing quasi-solutions and residue problems until it became painfully clear that a more rigorously tracked and structured approach would be required: Enter this project's GitHub repository.

Having a wealth of various IT-related and HTML/CSS development experience but virtually no experience in modern software development, frustration has (mostly) been overcome by an eagerness to learn and true enjoyment of the process -- especially the Mudlet community (see [Acknowledgments](#acknowledgements)).

The repo started with a [README-first approach](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html) to conceptualize how best to go about this project. discMapper was open-sourced upon conception.

#### Milestones

- v0.1.0-alpha - Initial
- v0.1.2-alpha - Core mapping features with GMCP support
- v0.2.1-beta - Help system and configuration functional
- v0.3.0-beta - Automated updates implemented
- v0.4.0-beta - Room Styling implemented
- v0.5.0-beta - Clean install process and initial default colors

### Vision

As complement to a planned Mudlet UI for Discworld MUD, the aim of this project is to provide existing and potential players with a newbie-friendly (accessible) and reliable means to map and navigate the Discworld MUD in an elegeant, modern MUD client. In line with that aim, the goal of this project is to release a Mudlet package with all the requisite aliases, triggers, and scripts. Ultimately, my hope is that discMapper might become a part of a larger Mudlet package for Discworld MUD, including guild-specific UI feature setss.
-->
### Features

- Automatic GMCP mapping of Procedural Realms MUD
- (broken) Speedwalking and pathfinding - Efficiently get where you're going - and fast!
- Automatic GMCP room styling based on terrain.
  - Matches colors in PR's 'map' and 'look' quickmap.
- Automatic harvesting trigger examples.
- Graphical bar gauges for charcater vitals, including Hit Points, Energy, and Stamina.

### Built With

- [Lua](https://www.lua.org) is the programming language
- [Edbee Library](https://github.com/edbee/edbee-lib) provides the text editor component for Mudlet
- [Mudlet](https://github.com/Mudlet/Mudlet) is a cross-platform, open source, and super fast MUD client
- [Git](https://git-scm.com) is the version-control system for tracking changes and project management
- [ImgBot](https://github.com/dabutvin/Imgbot) provides GitHub-integrated image optimization

### Versioning

Version numbering approximates the [Semantic Versioning](http://semver.org) approach.

### Project Status
<!-- Describe the current release and any notes about the current state of the project. Examples: currently compiles on your host machine, but is not cross-compiling for ARM, APIs are not set, feature not implemented, etc. -->

[![Status Ventis][status-ventis]][andivionian-status-classifier] ![Travis (.com) branch](https://img.shields.io/travis/com/iLPdev/discMapper/develop?style=flat)

- **Project State**: Prcedural Realms Script is under active development. The application can be used, but may be unstable. We are in need of beta testing prior to moving forward with the v1.0.0 release.

- **Current Release**: None yet.

**[^Top](#table-of-contents)**

<!-- GETTING STARTED 
## Install

The [Mudlet Makers](https://github.com/Mudlet/Mudlet/graphs/contributors) could not have made it easier to install preconfigured custom aliases, triggers, scripts, keybindings, and UIs.

### One-Click Install Method

Copy/paste the following command into Mudlet's input line to install discMapper:

```lua
lua function d(a,b)if not b:find("oci",1,true)then return end installPackage(b)os.remove(b)cecho("<lime_green>discMapper package installed!\n")end registerAnonymousEventHandler("sysDownloadDone","d")downloadFile(getMudletHomeDir().."/oci.mpackage","https://github.com/iLPdev/discMapper/releases/download/v0.5.0-beta/discMapper_v0.5.0-beta.mpackage")
```

### Package Install Method

Just like any other package as of Mudlet v4.8+, you may install discMapper by simply dragging and droppping the package file into Mudlet. discMapper will then be merged into your active Mudlet profile, and you may delete the original file.

To install discMapper, just follow these steps:

1. Locate the [latest release](https://github.com/iLPdev/discMapper/releases/latest) of discMapper.
1. Download the .mpackage file listed under Assets.
1. Open Mudlet on your operating system of choice.
1. Open an existing Discworld MUD profile or create a new one.
1. Locate the saved file on your PC.
1. Drag and drop the file into your open Discworld MUD profile.
1. Optionally, delete the .mpackage file from your computer.

### Dependencies

<a href="https://www.mudlet.org"><img src="https://www.mudlet.org/wp-content/uploads/2017/08/mudlet-wp-logo.png" alt="Mudlet" width="120" height="auto"></a>

- [Game-icons.net Font](https://github.com/toddfast/game-icons-net-font) v20200315 by Todd Fast provides 3,000+ map room symbols
- [Mudlet][mudlet-url] MUD Client application must obviously be installed on your operating system (Windows, MacOS, and Linux)

### Getting the Source

The discMapper project is [hosted on GitHub](https://github.com/iLPdev/discMapper). All versions of the repository are available as [releases](https://github.com/iLPdev/discMapper/releases).

You can also clone the entire project directly with this command: `git clone git@github.com:iLPdev/discMapper.git`

**[^Top](#table-of-contents)**
-->
<!-- USAGE EXAMPLES 
## Usage

<!-- Code block illustrating common usage.
     If CLI compatible, code block indicating common usage.
     Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.
     Cover basic choices that may affect usage: for instance, if JavaScript, cover promises/callbacks, ES6 here.
     If relevant, point to a runnable file for the usage code. 

To get started, connect to Discworld MUD in Mudlet and then enter `map basics` at the prompt.

A simple help system covering basic usage, most commands, and configuration options is available by issuing the `map help` command at the prompt.

<!-- _For more examples, please refer to the [Documentation](https://example.com)_ -->

**[^Top](#table-of-contents)**

<!-- ROADMAP -->
## Roadmap

The primary objective is to develop and test a minimally viable package for Mudlet that meets the requirements for includion on the list of connectable games when Mudlet starts and, in turn, to increase the playerbase of Procedural Realms.

Planned new features include:

See also the [open issues](https://github.com/iLPdev/prs/issues) for a list of proposed features (and known issues).

**[^Top](#table-of-contents)**

<!-- MAINTAINER(S) -->
## Maintainer

[@Stack](https://github.com/iLPdev) - Stop by and say hello on the [Mudlet Discord Server](https://discordapp.com/invite/kuYvMQ9)!

**[^Top](#table-of-contents)**

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

<!-- State anyone or anything that significantly helped with the development of your project.
     State public contact hyper-links if applicable. -->

- @Blizzard for his Simple GMCP Mapper script and responsiveness to all my questions.
- `README.md`:
  - [Best-README-Template](https://github.com/othneildrew/Best-README-Template) for initial inspiration
  - [Standard Readme](https://github.com/RichardLitt/standard-readme) specifcation
  - [Shields.io](https://shields.io/) for serving badges

**[^Top](#table-of-contents)**

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing space to be learn, inspire, and create. Any contributions you make are **greatly appreciated** -- that’s the main reason discMapper is open-sourced! There are so many ways to contribute, even if you’re not a technical person. All contributions--no matter how small---are always welcome. 

See the [open issues](https://github.com/iLPdev/prs/issues) for a list of ideas, questions, proposed features, and known issues.

There is not an explicit workflow requirement for this project, yet. I'm currently exprimenting with the [Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) approach and [Conventional Commits](https://www.conventionalcommits.org/), but you don't need to.

Basically, to contribute to this project, you're invited to:

1. Create an Issue (bug report / feature request)
1. Fork the Repository
1. Create your Branch (optionally reference issue in branch name; `git checkout -b feature/AmazingFeature`)
1. Code Code Code
1. Commit your Changes (incrementally with detailed commit messages; `git commit -m 'Add some AmazingFeature'`)
1. Push to your Branch (`git push origin feature/AmazingFeature`)
1. Submit a Pull Request

### Ethics

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md) and operates under the W3C's [Code of Ethics and Professional Conduct](https://www.w3.org/Consortium/cepc):

> W3C is a growing and global community where participants choose to work
> together, and in that process experience differences in language, location,
> nationality, and experience. In such a diverse environment, misunderstandings
> and disagreements happen, which in most cases can be resolved informally. In
> rare cases, however, behavior can intimidate, harass, or otherwise disrupt one
> or more people in the community, which W3C will not tolerate.
>
> A Code of Ethics and Professional Conduct is useful to define accepted and
> acceptable behaviors and to promote high standards of professional
> practice. It also provides a benchmark for self evaluation and acts as a
> vehicle for better identity of the organization.

The expectation is that our community group acts according to these guidelines, and that participants hold each other to these high standards. If you have any questions or are worried that the code isn't being followed, please contact the [maintainer](#maintainer) of this repository.

## Contributors

We following the [all-contributors][ac-url] specification: Contributions of any kind are welcome!

Thanks go to these amazing folks ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://ilpdev.com"><img src="https://avatars1.githubusercontent.com/u/1428343?v=4" width="50px;" alt=""/><br /><sub><b>Stack</b></sub></a><br /><a href="https://github.com/iLPdev/discMapper/commits?author=iLPdev" title="Code">💻</a> <a href="#design-iLPdev" title="Design">🎨</a> <a href="https://github.com/iLPdev/discMapper/commits?author=iLPdev" title="Documentation">📖</a> <a href="#infra-iLPdev" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-iLPdev" title="Maintenance">🚧</a> <a href="#projectManagement-iLPdev" title="Project Management">📆</a></td>
  </tr>
</table>
<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

**[^Top](#table-of-contents)**

<!-- LICENSE -- Must be last section. -->
## License

Copyleft (2022) _iLP development_. Distributed under GPL v3.0-and-later. For more
information, see license in [`COPYING`](https://github.com/iLPdev/discMapper/blob/master/COPYING).

**[^Top](#table-of-contents)**

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/iLPdev/prs.svg?style=flat-square
[contributors-url]: https://github.com/iLPdev/prs/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/iLPdev/prs.svg?style=flat-square
[forks-url]: https://github.com/iLPdev/prs/network/members
[stars-shield]: https://img.shields.io/github/stars/iLPdev/prs.svg?style=flat-square
[stars-url]: https://github.com/iLPdev/prsstargazers
[issues-shield]: https://img.shields.io/github/issues/iLPdev/prs.svg?style=flat-square
[issues-url]: https://github.com/iLPdev/prs/issues
[license-shield]: https://img.shields.io/github/license/iLPdev/prs.svg?style=flat-square
[license-url]: https://github.com/iLPdev/prs/blob/master/LICENSE.txt
[standard-readme-shield]: https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square
[standard-readme-url]: https://github.com/RichardLitt/standard-readme
[andivionian-status-classifier]: https://github.com/ForNeVeR/andivionian-status-classifier#status-ventis-
[status-ventis]: https://img.shields.io/badge/status-ventis-yellow.svg
[mudlet-url]: https://www.mudlet.org
[ac-url]: https://github.com/all-contributors/all-contributors
