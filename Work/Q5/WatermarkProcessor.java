import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

public class WatermarkProcessor {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java WatermarkProcessor <input-folder> <student-name>");
            return;
        }

        String folderPath = args[0];
        String studentName = args[1];

        File folder = new File(folderPath);
        File[] images = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".png") || name.toLowerCase().endsWith(".jpg"));

        if (images == null) {
            System.out.println("No images found in the directory.");
            return;
        }

        for (File imageFile : images) {
            try {
                BufferedImage image = ImageIO.read(imageFile);
                Graphics2D g2d = image.createGraphics();
                g2d.setFont(new Font("Arial", Font.BOLD, 50));
                g2d.setColor(new Color(255, 0, 0, 100)); // Transparent red
                g2d.drawString(studentName, 50, 50);
                g2d.dispose();

                File output = new File(folderPath + "/watermarked_" + imageFile.getName());
                ImageIO.write(image, "png", output);
                System.out.println("Watermarked: " + output.getName());

            } catch (Exception e) {
                System.out.println("Error processing " + imageFile.getName());
            }
        }
    }
}
