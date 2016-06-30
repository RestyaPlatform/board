/**
 * @fileOverview This file has functions related to list delete confirm view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. It contain all list based object @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ListDeleteConfirm View
 * @class ArchiveDeleteConfirmView
 * @constructor
 * @extends Backbone.View
 */
App.ArchiveCardDeleteConfirmView = Backbone.View.extend({
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
    template: JST['templates/archive_card_delete_confirm'],
    tagName: 'div',

    events: {
        'click .js-delete-all-archived-cards-delete': 'deleteAllArchivedCards',
        'click .js-close-popup': 'closePopup',
    },
    deleteAllArchivedCards: function(e) {
        var self = this;
        self.model.url = api_url + 'boards/' + self.model.id + '/cards.json';
        self.model.destroy({
            success: function(model, response) {
                self.model.cards.each(function(card) {
                    if (!_.isUndefined(card) && !_.isUndefined(card.attributes) && card.attributes.is_archived === 1) {
                        card.collection.remove(card);
                    }
                });
                self.flash('success', i18next.t('Cards deleted successfully.'));
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
            list: this.model
        }));
        this.showTooltip();
        return this;
    }
});
