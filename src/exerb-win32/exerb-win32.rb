#! /usr/bin/ruby

#==============================================================================#
# $Id: exerb-win32.rb,v 1.10 2005/04/15 10:51:40 yuya Exp $
#==============================================================================#

require 'etklib'
require 'pstore'
require 'exerb/recipe'
require 'exerb/executable'
require 'exerb/resource'

#==============================================================================#

class ExerbWin32 < Etk::Form

  CORE_INFORMATION = {
    'ruby182c.exc'   => 'ruby 1.8.2 / CUI / stand-alone',
    'ruby182g.exc'   => 'ruby 1.8.2 / GUI / stand-alone',
    'ruby182crt.exc' => 'ruby 1.8.2 / CUI / using runtime-library',
    'ruby182grt.exc' => 'ruby 1.8.2 / GUI / using runtime-library',
    'ruby190c.exc'   => 'ruby 1.9.0 / CUI / stand-alone / unstable',
    'ruby190g.exc'   => 'ruby 1.9.0 / GUI / stand-alone / unstable',
  }

  def initialize
    $form = self
    $basedir = File.dirname(File.expand_path(Exerb.filepath))
    $db_path = File.join($basedir, 'exerb-win32.config')

    self.text         = 'exerb-win32'
    self.maximize_box = false
    self.border_style = Etk::Form::BORDER_STYLE_FIXED_SINGLE
    self.set_client_size(445, 155)

    self.suspend_layout {
      [
        [Etk::Label,    :core_label,    'Exerb Core',      10,  10,  70, 20],
        [Etk::ComboBox, :core_name,     '',                90,  10, 340, 20],
        [Etk::Label,    :recipe_label,  'Recipe',          10,  35,  70, 20],
        [Etk::EditBox,  :recipe_path,   '',                90,  35, 320, 20],
        [Etk::Button,   :recipe_browse, '...',            410,  35,  20, 20],
        [Etk::Label,    :output_label,  'Output',          10,  60,  70, 20],
        [Etk::EditBox,  :output_path,   '',                90,  60, 320, 20],
        [Etk::Button,   :output_browse, '...',            410,  60,  20, 20],
        [Etk::Label,    :option_label,  'Option',          10,  85,  70, 20],
        [Etk::CheckBox, :upx_mode,      'Compress by UPX', 90,  85, 120, 20],
        [Etk::EditBox,  :upx_path,      '',               220,  85, 190, 20],
        [Etk::Button,   :upx_browse,    '...',            410,  85,  20, 20],
        [Etk::Label,    :status,        '',                10, 120, 260, 25],
        [Etk::Button,   :generate,      'Generate',       290, 120, 140, 25],
      ].each { |klass, name, text, x, y, dx, dy|
        self << klass.new(name, text, x, y, dx, dy)
      }
    }

    self[:core_label].text_align   = Etk::Label::TEXT_ALIGN_MIDDLE_RIGHT
    self[:recipe_label].text_align = Etk::Label::TEXT_ALIGN_MIDDLE_RIGHT
    self[:output_label].text_align = Etk::Label::TEXT_ALIGN_MIDDLE_RIGHT
    self[:option_label].text_align = Etk::Label::TEXT_ALIGN_MIDDLE_RIGHT
    self[:status].text_align       = Etk::Label::TEXT_ALIGN_MIDDLE_LEFT

    $core_files = Exerb::CORE_PATH.collect { |dirname| Dir.glob(File.join(dirname, '*.exc')) }
    $core_files.flatten!
    $core_files.collect! { |filepath| File.expand_path(filepath) }
    $core_files.uniq!
    $core_files.sort!
    $core_files.each { |filepath|
      filename = File.basename(filepath)
      info     = CORE_INFORMATION[filename]
      self[:core_name].add((info ? '%s (%s)' : '%s') % [filename, info])
    }

    self[:core_name].style = Etk::ComboBox::STYLE_DROP_DOWN_LIST
    self[:core_name].selected_index = 0 if self[:core_name].count > 0
    self[:status].border_style = Etk::Label::BORDER_STYLE_FIXED_3D

    def self.on_closed(arg)
      PStore.new($db_path).transaction { |db|
        db[:core_name]   = self[:core_name].selected_index
        db[:recipe_path] = self[:recipe_path].text
        db[:output_path] = self[:output_path].text
        db[:upx_mode]    = self[:upx_mode].checked
        db[:upx_path]    = self[:upx_path].text
        db.commit
      }
    end

    def (self[:recipe_browse]).on_click(arg)
      dialog = Etk::OpenFileDialog.new
      dialog.filter = "Recipe files (*.exr)|*.exr|All files (*.*)|*.*"
      return unless dialog.show

      $form[:recipe_path].text = dialog.filename
      $form[:output_path].text = dialog.filename.sub(/(\.exr$|$)/i, '.exe')
    end

    def (self[:output_browse]).on_click(arg)
      dialog = Etk::OpenFileDialog.new
      dialog.filter = "Executable files (*.exe)|*.exe|All files (*.*)|*.*"
      dialog.check_file_exists = false
      return unless dialog.show

      $form[:output_path].text = dialog.filename
    end

    def (self[:upx_mode]).on_checked_changed(arg)
      $form[:upx_path].enabled   = $form[:upx_mode].checked
      $form[:upx_browse].enabled = $form[:upx_mode].checked
    end

    def (self[:upx_browse]).on_click(arg)
      dialog = Etk::OpenFileDialog.new
      dialog.filter = "Executable files (*.exe)|*.exe|All files (*.*)|*.*"
      return unless dialog.show

      $form[:upx_path].text = dialog.filename
    end

    def (self[:generate]).on_click(arg)
      $form[:status].text = 'initialize...'

      recipe_filepath = $form[:recipe_path].text
      output_filepath = $form[:output_path].text
      upx_mode        = $form[:upx_mode].checked
      upx_filepath    = $form[:upx_path].text

      [
        [$form[:core_name].selected_index < 0, $form[:core_name],   'Please choose a core file.'],
        [recipe_filepath.empty?,               $form[:recipe_path], 'Please input file name of recipe.'],
        [output_filepath.empty?,               $form[:output_path], 'Please input file name of output.'],
        [upx_mode && upx_filepath.empty?,      $form[:upx_path],    'Please input file name of UPX.'],
      ].each { |cond, ctrl, msg|
        next unless cond
        Etk.msgbox(msg, 'exerb-win32', Etk::MSGBOX_BUTTON_OK, Etk::MSGBOX_ICON_WARNING)
        ctrl.focus
        $form[:status].text = 'error'
        return
      }

      core_filepath   = $core_files[$form[:core_name].selected_index]
      recipe_filepath = File.expand_path(recipe_filepath, $basedir)
      output_filepath = File.expand_path(output_filepath, File.dirname(recipe_filepath))
      upx_filepath    = File.expand_path(upx_filepath, $basedir)

      [
        [!File.exist?(core_filepath),                 $form[:core_name],   'no such core file.'],
        [!File.exist?(recipe_filepath),               $form[:recipe_path], 'no such recipe file.'],
        [!File.exist?(File.dirname(output_filepath)), $form[:output_path], 'no such output directory.'],
        [upx_mode && !File.exist?(upx_filepath),      $form[:upx_path],    'no such upx file.'],
      ].each { |cond, ctrl, msg|
        next unless cond
        Etk.msgbox(msg, 'exerb-win32', Etk::MSGBOX_BUTTON_OK, Etk::MSGBOX_ICON_WARNING)
        ctrl.focus
        $form[:status].text = 'error'
        return
      }

      if File.exist?(output_filepath) && Etk.msgbox("'#{output_filepath}' exists already.\nDo you want to overwrite?", 'exerb-win32', Etk::MSGBOX_BUTTON_YES_NO, Etk::MSGBOX_ICON_QUESTION) == Etk::DIALOG_RESULT_NO
        return
      end

      begin
        $form[:status].text = 'loading recipe...';     recipe     = Exerb::Recipe.new_from_file(recipe_filepath)
        $form[:status].text = 'creating archive...';   archive    = recipe.archive
        $form[:status].text = 'loading core...';       executable = Exerb::Executable.new_from_file(core_filepath)
        $form[:status].text = 'creating output...';    executable.rsrc.add_archive(archive)
        $form[:status].text = 'writing output...';     executable.write_to_file(output_filepath)
        $form[:status].text = 'compressing output...'; system(upx_filepath, output_filepath) if upx_mode
        $form[:status].text = 'complete'

        complete_message = format(%|Completed!\n\nCore file\t\t: %s\nRecipe file\t: %s\nOutput file\t: %s\nSize of output file\t: %i byte|, core_filepath, recipe_filepath, output_filepath, File.stat(output_filepath).size)
        Etk.msgbox(complete_message, 'exerb-win32', Etk::MSGBOX_BUTTON_OK, Etk::MSGBOX_ICON_INFORMATION)
      rescue Exception => e
        case e
        when Exerb::ExerbError then message = e.message
        else message = "#{e.class.name}\n#{e.message}"
        end
        Etk.msgbox(format("Failed!\n\n%s", message), 'exerb-win32', Etk::MSGBOX_BUTTON_OK, Etk::MSGBOX_ICON_ERROR)
        $form[:status].text = 'error'
      end
    end

    self[:upx_mode].checked = true

    PStore.new($db_path).transaction { |db|
      self[:core_name].selected_index = db[:core_name] if db[:core_name] && db[:core_name] < self[:core_name].count
      self[:recipe_path].text = db[:recipe_path] || ""
      self[:output_path].text = db[:output_path] || ""
      self[:upx_mode].checked = db[:upx_mode]    || false
      self[:upx_path].text    = db[:upx_path]    || ""
    }
  end

end

#==============================================================================#

Etk.main(ExerbWin32.new)

#==============================================================================#
#==============================================================================#
