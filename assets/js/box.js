/**
 * BoxBilling
 *
 * @copyright BoxBilling (https://boxbilling.org)
 * @license   Apache-2.0
 *
 * Copyright BoxBilling
 * This source file is subject to the Apache-2.0 License that is bundled
 * with this source code in the file LICENSE
 */

function getLatestReleaseVersion() {
    // Let's see if the browser supports fetch()
    if (window.fetch) {
        // It does, now let's fetch from GitHub releases
        fetch('https://api.github.com/repos/boxbilling/boxbilling/releases/latest')
        .then(response => response.json())
        .then(data => {
            // Using release data
            document.getElementById('latest-release-date').innerHTML = `Latest release: ${new Date(data.published_at).toLocaleDateString()}`;
            document.getElementById('release-notes').innerHTML = `<a class="text-decoration-none" href="${data.html_url}" target="_blank">Release notes</a>`;
            document.getElementById('download-text').innerHTML = data.tag_name;
            document.getElementById('navbar-download').setAttribute('href', data.assets[0].browser_download_url);
            document.getElementById('primary-download').setAttribute('href', data.assets[0].browser_download_url);
        }).catch(error => {
            // Uh oh
            console.error('There has been a problem while fetching versioning details from GitHub releases:', error);
        });
      } else {
        // It doesn't
        console.error('Your browser does not support fetching from another source. Details about the latest release were not fetched from GitHub, showing dummy values instead.')
      }
}

function loader() {
    getLatestReleaseVersion();
}

window.onload = loader;
