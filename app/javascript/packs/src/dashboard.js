document.addEventListener('DOMContentLoaded', () => {
    // Get all "has-children" elements
    let withChildren = document.querySelectorAll('.menu .has-children')
    let sidebar = document.querySelector('#main-sidebar')
    let addPulsecheckerIcon = document.querySelector('#add-pulsechecker-icon')
    // Toggle sidebar
    let sidebarToggler = document.querySelector('#sidebar-toggler')
    let mainContent = document.querySelector('#main')
    let footerCopyright = document.querySelector('#copyright')

    withChildren.forEach(function (wChildrenEl) {
        wChildrenEl.addEventListener('click', function () {
            wChildrenEl.classList.toggle('open')
            if (sidebar.classList.contains('closed')) sidebar.classList.remove('closed')
        })
    })

    sidebarToggler.addEventListener('click', () => {
        sidebar.classList.toggle('closed')
        addPulsecheckerIcon.classList.toggle('open')

        if (sidebar.classList.contains('closed')) {
            withChildren.forEach(function (wChildrenEl) {
                wChildrenEl.classList.remove('open')
            })

            mainContent.classList.add('sidebar--closed')
            footerCopyright.classList.add('sidebar--closed')
        } else {
            mainContent.classList.remove('sidebar--closed')
            footerCopyright.classList.remove('sidebar--closed')
        }
    });

    (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
        const $notification = $delete.parentNode;

        // add addEventListener for close btn
        $delete.addEventListener('click', () => {
            $notification.parentNode.removeChild($notification);
        });
        // hide notification after 3 seconds
        setTimeout(() => {
            $notification.classList.add('hide');
            $notification.parentNode.removeChild($notification);
        }, 3000);
    });
})