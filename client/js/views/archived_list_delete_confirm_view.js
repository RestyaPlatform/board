/**
 * @fileOverview This file has functions related to list delete confirm view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. It contain all list based object @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardDeleteConfirm View
 * @class ArchiveDeleteConfirmView
 * @constructor
 * @extends Backbone.View
 */
App.ArchivedListDeleteConfirmView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/archived_list_delete_confirm'],
    tagName: 'div',

    events: {
        'click .js-delete-archived-list': 'deleteArchivedList',
        'click .js-close-popup': 'closePopup',
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            list: this.model
        }));
        this.showTooltip();
        return this;
    },
    deleteArchivedList: function(e) {
        var self = this;
        $('.js-delete-archived-list').addClass('disabled');
        var list_id = self.model.id;
        self.model.collection.remove(self.model);
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + list_id + '.json';
        self.model.destroy({
            success: function(model, response) {
                var activity = new App.Activity();
                activity.set(response.activity);
                self.flash('success', i18next.t('List deleted successfully.'));
                $('.js-archived-items').trigger('click');
            }
        });
        return false;
    },
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown:first, div.dropdown:first').removeClass('open');
        return false;
    },
});
