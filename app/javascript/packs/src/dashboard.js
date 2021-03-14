document.addEventListener('DOMContentLoaded', () => {
  // Get all "has-children" elements
  const withChildren = document.querySelectorAll('.menu .has-children');
  const sidebar = document.querySelector('#main-sidebar');
  // Toggle sidebar
  const sidebarToggler = document.querySelector('#sidebar-toggler');
  const mainContent = document.querySelector('#main');
  const footerCopyright = document.querySelector('#copyright');

  withChildren.forEach((wChildrenEl) => {
    wChildrenEl.addEventListener('click', () => {
      wChildrenEl.classList.toggle('open');
      if (sidebar.classList.contains('closed')) sidebar.classList.remove('closed');
    });
  });

  sidebarToggler.addEventListener('click', () => {
    sidebar.classList.toggle('closed');

    if (sidebar.classList.contains('closed')) {
      withChildren.forEach((wChildrenEl) => {
        wChildrenEl.classList.remove('open');
      });

      mainContent.classList.add('sidebar--closed');
      footerCopyright.classList.add('sidebar--closed');
    } else {
      mainContent.classList.remove('sidebar--closed');
      footerCopyright.classList.remove('sidebar--closed');
    }
  });
});
