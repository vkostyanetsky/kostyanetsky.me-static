// Hotkeys

document.addEventListener('keydown', function(event) {

    if (! (event.ctrlKey || event.metaKey)) return;

    if (event.code == 'ArrowUp') {
        goToUrl(event, ctrlUpUrl);
    }
    else if (event.code == 'ArrowDown') {
        goToUrl(event, ctrlDownUrl);
    }
    else if (event.code == 'ArrowLeft') {
        goToUrl(event, ctrlLeftUrl);
    }
    else if (event.code == 'ArrowRight') {
        goToUrl(event, ctrlRightUrl);
    }        

});

function goToUrl(event, href) {

    if (href != '') {

        event.preventDefault();
        document.location.href = href;    

    }

} // goToUrl()