document.addEventListener('DOMContentLoaded', function () {
    // Get all "has-children" elements
    let withChildren = document.querySelectorAll('.menu .has-children')
    let sidebar = document.querySelector('#main-sidebar')
    // Toggle sidebar
    let sidebarToggler = document.querySelector('#sidebar-toggler')
    let mainContent = document.querySelector('#main')
    let footerCopyright = document.querySelector('#copyright')

    let menuItems = document.getElementsByClassName('menu-item');

    for (let i = 0; i < menuItems.length; i++) {
        menuItems[i].addEventListener('click', (e) => activeMenuItem(e, menuItems[i]));
    }

    let activeMenuItem = (event, item) => {
        event.preventDefault()
        let activeMenuItems = document.getElementsByClassName('menu-item is-active');
        for (let i = 0; i < activeMenuItems.length; i++) {
            activeMenuItems[i].classList.remove('is-active');
        }
        item.classList.add('is-active');
    };


    withChildren.forEach(function (wChildrenEl) {
        wChildrenEl.addEventListener('click', function () {
            wChildrenEl.classList.toggle('open')
            if (sidebar.classList.contains('closed')) sidebar.classList.remove('closed')
        })
    })

    sidebarToggler.addEventListener('click', function () {
        sidebar.classList.toggle('closed')

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
    })
})
