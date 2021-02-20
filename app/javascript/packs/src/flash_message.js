document.addEventListener('DOMContentLoaded', () => {
    (document.querySelectorAll('.notification .delete') || []).forEach((btn_delete) => {
        const notification = btn_delete.parentNode;

        // add addEventListener for close btn
        btn_delete.addEventListener('click', () => {
            notification.parentNode.removeChild(notification);
        });
        // hide notification after 3 seconds
        setTimeout(() => {
            notification.classList.add('hide');
            notification.parentNode.removeChild(notification);
        }, 3000);
    });
})
