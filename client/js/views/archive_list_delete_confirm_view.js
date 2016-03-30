/**
 * @fileOverview This file has functions related to archived lists view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model and it's related values. It contain all list based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ArchivedLists View
 * @class ArchivedListsView
 * @constructor
 * @extends Backbone.View
 */
App.ArchiveListDeleteConfirmView = Backbone.View.extend({
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
    template: JST['templates/archive_list_delete_confirm'],
    tagName: 'div',
    className: 'clearfix col-xs-12',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-all-archived-list-delete': 'deleteAllArchivedlists',
        'click .js-close-popup': 'closePopup',
    },
    deleteAllArchivedlists: function(e) {
        var self = this;
        self.model.url = api_url + 'boards/' + self.model.id + '/lists.json';
        self.model.destroy({
            success: function(model, response) {
                self.model.lists.each(function(list) {
                    if (!_.isUndefined(list) && !_.isUndefined(list.attributes) && list.attributes.is_archived === 1) {
                        list.collection.remove(list);
                    }
                });
                self.flash('success', i18next.t('Lists deleted successfully.'));
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
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            list: this.model,
        }));
        this.showTooltip();
        return this;
    }

});
