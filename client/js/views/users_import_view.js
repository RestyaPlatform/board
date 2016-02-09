/**
 * @fileOverview This file has functions related to users import view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined
 */
if (typeof App == 'undefined') {
    App = {};
}
App.UsersImportView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.render();
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#UploadForm': 'submitUpload',
    },
    template: JST['templates/users_import'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(collections) {
        this.$el.html(this.template({
            type: 'all',
        }));
        return this;
    },
    submitUpload: function(e) {
        e.preventDefault();
        var self = this;
        var form = $(e.target);
        var fileData = new FormData(form[0]);
        console.log(fileData);
        var User = new App.User();
        User.url = api_url + 'users/import.json';
        User.save(fileData, {
            patch: true,
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            success: function(model, response) {
                if (response.success) {
                    self.flash('success', i18next.t('Imported successfully.'));
                } else if (response.error === 'file_format') {
                    self.flash('danger', i18next.t('File extension not supported. It supports only csv.'));
                } else if (response.error === 'not_import') {
                    self.flash('danger', i18next.t('Not imported, Try again.'));
                }
            }
        });
        return false;
    },
});
