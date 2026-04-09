# Ubuntu Packages For R - Brief Instructions

## Install R

Packages for the current R 4.5 release* are available for Ubuntu Long Term Support (LTS) releases. Supported releases as of April 15, 2025:

* 24.04 (“noble”, amd64 and arm64)
* 22.04 (“jammy”, amd64 and arm64)
* 20.04 (“focal”, amd64 and arm64)

Run the commands below to configure your system for R binaries from CRAN, install R and its dependencies, and set up the repository for updates. `lsb_release -cs` automatically selects your Ubuntu release (e.g., noble, jammy, focal).

---

## Installation Steps

### User/Root

```bash
# update indices
sudo apt update -qq

# install helper packages
sudo apt install --no-install-recommends software-properties-common dirmngr

# add the signing key for CRAN repos
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# add the CRAN repo (adjusts automatically to 'noble', 'jammy', etc.)
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# install R
sudo apt install --no-install-recommends r-base r-base-dev
```

---

## Install RStudio

1. **Download the latest RStudio Desktop for Ubuntu**:

```bash
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2026.03.0-386-amd64.deb
```

*(Check [https://posit.co/download/rstudio/](https://posit.co/download/rstudio/) for the latest version.)*

2. **Install the RStudio package**:

```bash
sudo apt install ./rstudio-2026.03.0-386-amd64.deb
```

3. **Launch RStudio**:

```bash
rstudio
```

---

## See Also

* For full instructions including administration and package maintenance, see the full README.
* To install all 24,000+ CRAN and BioConductor packages as binaries, use the [r2u project](https://r2u.stat.ox.ac.uk/).
* The c2d4u project is no longer updated; use r2u instead.

---

## Acknowledgements

* Debian R packages and r2u project maintained by Dirk Eddelbuettel
* Ubuntu packages compiled by Michael Rutter ([marutter@gmail.com](mailto:marutter@gmail.com))
* Original instructions developed with Vincent Goulet
* Questions can be directed to the [R-SIG-Debian mailing list](https://stat.ethz.ch/mailman/listinfo/r-sig-debian)

---

