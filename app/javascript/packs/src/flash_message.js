document.addEventListener('DOMContentLoaded', () => {
  (document.querySelectorAll('.notification .delete') || []).forEach((btnDelete) => {
    const notification = btnDelete.parentNode;

    // add addEventListener for close btn
    btnDelete.addEventListener('click', () => {
      notification.parentNode.removeChild(notification);
    });

    // hide notification after 3 seconds
    setTimeout(() => {
      notification.classList.add('hide');
      notification.parentNode.removeChild(notification);
    }, 3000);
  });
});
